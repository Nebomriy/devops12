FROM python:3.14.2-slim

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

# CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "app:app"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
