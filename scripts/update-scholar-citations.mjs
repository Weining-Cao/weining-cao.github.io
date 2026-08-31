import { writeFile } from 'node:fs/promises';

const scholarUrl = 'https://scholar.google.com/citations?user=g9oDZ_AAAAAJ&hl=en';
const response = await fetch(scholarUrl, {
  headers: {
    'User-Agent': 'Mozilla/5.0 (compatible; WeiningCaoHomepageMetrics/1.0)'
  }
});

if (!response.ok) {
  throw new Error(`Google Scholar responded with HTTP ${response.status}`);
}

const profile = await response.text();
if (!profile.includes('Weining Cao')) {
  throw new Error('Google Scholar returned an unexpected profile');
}

const citationMatch = profile.match(/Cited by\s+([\d,]+)/);
if (!citationMatch) {
  throw new Error('Could not find the citation count in the Google Scholar profile');
}

const googleScholarCitations = Number(citationMatch[1].replaceAll(',', ''));
if (!Number.isSafeInteger(googleScholarCitations) || googleScholarCitations < 0) {
  throw new Error('Google Scholar returned an invalid citation count');
}

const metrics = {
  googleScholarCitations,
  updatedAt: new Date().toISOString(),
  source: scholarUrl
};

if (process.argv.includes('--dry-run')) {
  console.log(`Google Scholar citations: ${googleScholarCitations}`);
} else {
  await writeFile(new URL('../metrics.json', import.meta.url), `${JSON.stringify(metrics, null, 2)}\n`);
  console.log(`Updated Google Scholar citations to ${googleScholarCitations}`);
}
