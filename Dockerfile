FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY src/ /app/

# Expose port
EXPOSE 5000

# Run Flask app
CMD ["python", "app.py"]
