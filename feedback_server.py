import json
import os
import smtplib
from datetime import datetime
from email.mime.text import MIMEText
from email.utils import formatdate
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


class FeedbackHandler(SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path != "/api/feedback":
            self.send_error(404)
            return

        content_length = int(self.headers.get("Content-Length", "0"))
        if content_length <= 0 or content_length > 10000:
            self.send_error(400)
            return

        try:
            data = json.loads(self.rfile.read(content_length).decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self.send_error(400)
            return

        message = str(data.get("message", "")).strip()
        if not message:
            self.send_error(400)
            return

        name = str(data.get("name", "")).strip() or "Anonymous reader"
        page = str(data.get("page", "")).strip() or "/"
        subject = "[Homepage] Blog feedback"
        body = (
            f"Name: {name}\n"
            f"Page: {page}\n"
            f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
            f"{message}"
        )

        if not send_email(subject, body):
            self.send_error(500)
            return

        response = json.dumps({"ok": True}).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(response)))
        self.end_headers()
        self.wfile.write(response)


def send_email(subject, content):
    smtp_server = os.getenv("SMTP_SERVER", "smtp.163.com")
    smtp_port = int(os.getenv("SMTP_PORT", "465"))
    sender_email = os.getenv("SENDER_EMAIL", "")
    sender_password = os.getenv("SENDER_PASSWORD", "")
    receiver_email = os.getenv("RECEIVER_EMAIL", "")

    if not all((smtp_server, smtp_port, sender_email, sender_password, receiver_email)):
        return False

    message = MIMEText(content, "plain", "utf-8")
    message["From"] = sender_email
    message["To"] = receiver_email
    message["Subject"] = subject
    message["Date"] = formatdate()

    with smtplib.SMTP_SSL(smtp_server, smtp_port) as server:
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, message.as_string())

    return True


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    server = ThreadingHTTPServer(("", port), FeedbackHandler)
    print(f"Serving on http://localhost:{port}")
    server.serve_forever()
