#!/usr/bin/env bash
set -e

echo "Waiting for postgres to connect ..."

while ! nc -z db 5432; do
  sleep 0.1
done

echo "PostgreSQL is active"

python manage.py migrate
python manage.py makemigrations
python manage.py collectstatic --noinput
python create_superuser.py

gunicorn conduit.wsgi:application --bind 0.0.0.0:8020

echo "Postgresql migrations finished"

python manage.py runserver