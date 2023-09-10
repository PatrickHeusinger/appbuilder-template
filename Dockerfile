FROM docker.io/node:lts-bullseye-slim as build-webapp
ENV BUILD_HOME /build
WORKDIR 
COPY webapp 
RUN apt-get update && apt-get install -y build-essential ca-certificates git     && corepack enable     && corepack prepare pnpm@latest-8 --activate     && pnpm install     && pnpm run build     && mkdir /pack/templates -p     && mv -t /pack/templates/ dist/index.html     && mv -t /pack/ dist/static



FROM docker.io/python:3.11 as build-app
COPY requirements.txt .
RUN apt-get update && apt-get upgrade && apt-get install -y build-essential libpq-dev ca-certificates git
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/Pat/Library/Application Support/JetBrains/Toolbox/scripts"
RUN pip install --trusted-host '*' --no-cache-dir -r requirements.txt


FROM docker.io/python:3.11
ENV APP_HOME /my-new-app
ENV PATH="/opt/venv/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/Pat/Library/Application Support/JetBrains/Toolbox/scripts:/opt/homebrew/bin:/opt/homebrew/sbin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/Pat/Library/Application Support/JetBrains/Toolbox/scripts:"
ENV PYTHONUNBUFFERED=1



RUN apt-get update && apt-get upgrade && apt-get install -y postgresql-client  && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=build-webapp /pack /app
COPY --from=build-app /opt/venv /opt/venv
COPY app /app
#COPY certs /usr/local/share/ca-certificates if your backend requries custom certificates e.g. for ldap
#RUN  update-ca-certificates
#ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt 

WORKDIR 
CMD ["gunicorn", "--bind=:8080", "app:app"]
