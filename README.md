# PolicyMaking - GRAINAI 

![GRAINAI Logo](frontend/public/logo_grainai.png)

> ⚠️ **Note:** This project is still under development.

AI-powered policy analysis and generation platform. Analyzes policy documents, identifies issues, and generates improved versions.

## Quick Start

**Requirements:** Docker & Docker Compose

```bash
git clone <repository-url>
cd PolicyMaking
docker-compose up -d
```

Access:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000/docs
- OLLAMA: http://localhost:11434

## Services

| Service | Port | Tech |
|---------|------|------|
| Frontend | 3000 | React 18 + Tailwind |
| Backend | 8000 | FastAPI + Python 3.11 |
| OLLAMA | 11434 | LLM Runtime |

## Project Structure

```
backend/          # FastAPI application
├── app/
│   ├── main.py
│   ├── routes/
│   ├── services/
│   └── utils/
└── requirements.txt

frontend/         # React application
├── src/
│   ├── components/
│   ├── App.js
│   └── api.js
└── package.json

terraform/        # Infrastructure as Code
ollama/           # LLM container
docker-compose.yml
```

## Development

### Backend
```bash
cd backend
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Frontend
```bash
cd frontend
npm install
npm start
```

## Common Commands

```bash
# Start all services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f <service>

# Check status
docker-compose ps
```

## Terraform Deployment

Deploy to cloud infrastructure (AWS, GCP, Azure):

```bash
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply

# View outputs
terraform output

# Destroy resources (if needed)
terraform destroy
```

## Troubleshooting

**Port already in use?**
```bash
lsof -i :3000  # Check frontend
lsof -i :8000  # Check backend
lsof -i :11434 # Check OLLAMA
```

**Container won't start?**
```bash
docker-compose logs <service>  # View errors
docker-compose down -v         # Clean and restart
docker-compose up -d
```

**OLLAMA not responding?**
```bash
curl http://localhost:11434/api/tags
docker-compose restart ollama
```

## Dependencies

**Backend:** fastapi, uvicorn, pydantic, ollama

**Frontend:** react, axios, tailwindcss, framer-motion

---

**Last Updated:** January 3, 2026
