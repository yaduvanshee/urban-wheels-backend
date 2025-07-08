# README

## How to Start the Project

### 1️⃣ Normal (Local Machine) Setup

**Requirements:**
- Ruby 3.2.2
- Rails 7.x
- PostgreSQL@16

**Steps:**

```sh
git clone git@github.com:yaduvanshee/urban-wheels-backend.git
cd urban-wheels-backend
```

```sh
bundle install
```

```sh
rails db:create db:migrate db:seed
```

```sh
rails server
```

App will be available at: [http://localhost:3000](http://localhost:3000)

---

### 2️⃣ Docker Setup

**Requirements:**
- Docker
- Docker Compose

**Steps:**

```sh
git clone git@github.com:yaduvanshee/urban-wheels-backend.git
cd urban-wheels-backend
```

```sh
docker-compose up --build
```

App will be available at: [http://localhost:3000](http://localhost:3000)

---

### 🔧 Useful Docker Commands

```sh
docker-compose exec web rails console
```

```sh
docker-compose exec web rails db:migrate
```

```sh
docker-compose restart web
```
