import { readFile, writeFile } from 'node:fs/promises';

const githubToken = process.env.GITHUB_TOKEN;
if (!githubToken) {
  throw new Error('GITHUB_TOKEN is required');
}

const githubOwner = 'Weining-Cao';
const groupProjectRepos = [
  'SoftWiser-group/I3DP',
  'SoftWiser-group/Clause2Inv'
];
const githubApiBase = 'https://api.github.com';
const headers = {
  Accept: 'application/vnd.github+json',
  Authorization: `Bearer ${githubToken}`,
  'X-GitHub-Api-Version': '2022-11-28',
  'User-Agent': 'WeiningCaoHomepageMetrics/1.0'
};

async function fetchJson(url) {
  const response = await fetch(url, { headers });
  if (!response.ok) {
    throw new Error(`GitHub API responded with HTTP ${response.status}`);
  }
  return response.json();
}

async function fetchPersonalRepositories() {
  const repositories = [];

  for (let page = 1; ; page += 1) {
    const pageRepositories = await fetchJson(
      `${githubApiBase}/users/${githubOwner}/repos?type=owner&per_page=100&page=${page}`
    );
    repositories.push(...pageRepositories);
    if (pageRepositories.length < 100) break;
  }

  return repositories;
}

const personalRepositories = await fetchPersonalRepositories();
const groupRepositories = await Promise.all(
  groupProjectRepos.map(repo => fetchJson(`${githubApiBase}/repos/${repo}`))
);
const repositories = [
  ...personalRepositories.filter(repo => !repo.private && !repo.fork && !repo.archived),
  ...groupRepositories
];
const uniqueRepositories = [...new Map(repositories.map(repo => [repo.full_name, repo])).values()];
const githubStars = uniqueRepositories.reduce((sum, repo) => sum + repo.stargazers_count, 0);
const metricsPath = new URL('../metrics.json', import.meta.url);
const metrics = JSON.parse(await readFile(metricsPath, 'utf8'));

metrics.githubStars = githubStars;
metrics.githubStarsUpdatedAt = new Date().toISOString();
metrics.githubStarsSource = [
  `https://api.github.com/users/${githubOwner}/repos`,
  ...groupProjectRepos.map(repo => `https://api.github.com/repos/${repo}`)
];

if (process.argv.includes('--dry-run')) {
  console.log(`GitHub Project Stars: ${githubStars}`);
} else {
  await writeFile(metricsPath, `${JSON.stringify(metrics, null, 2)}\n`);
  console.log(`Updated GitHub Project Stars to ${githubStars}`);
}
