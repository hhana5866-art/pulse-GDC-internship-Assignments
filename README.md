# Assignment 1 — Registration with Email OTP

Internship 2026 · Spring Security & Web track

A near-empty Spring Boot application. You are going to turn it into a
registration flow: sign up with an email and a password, receive a six-digit
code by email, and only become a real account once that code checks out.

> **This is the first of several assignments, and later ones build on this
> code.** Keep your fork — you will come back to it.

---

## Start here

**Read `docs/build-brief.html` before you write any code.** Open it in a
browser. It is the specification: the endpoints, the response envelope, the
error codes, the fixed values, and what "done" means at three levels.

Nothing in this README replaces it. This file just gets the project running.

---

## Run it

```bash
./mvnw spring-boot:run
```

On Windows:

```
mvnw.cmd spring-boot:run
```

The first run downloads Maven and the dependencies, so give it a minute. When
it starts you will see the Spring Boot banner and `Tomcat started on port 8080`.

Then:

```bash
curl -i http://localhost:8080/api/v1/registrations
```

You will get a 404 carrying Spring's default error body. That body is the first
thing the brief asks you to replace.

Run the tests with `./mvnw test`.

---

## Services: use Docker, or use your own

There is a `docker-compose.yml` with PostgreSQL, Redis and a mail server. It is
**optional**. If you already run PostgreSQL or Redis locally, use those and
point your configuration at them instead.

```bash
docker compose up -d      # start them
docker compose ps         # check they are up
docker compose down       # stop them
```

| Service | Where | Notes |
|---|---|---|
| PostgreSQL | `localhost:5432` | db `registration`, user `registration`, password `registration` |
| Redis | `localhost:6379` | no password |
| Mail | `localhost:1025` (SMTP) | **inbox at http://localhost:8025** |

The mail server accepts every message and delivers none of them — your codes
show up in that web inbox instead of a real mailbox. That is what you develop
against.

---

## What's in here, and what isn't

**In here:** the Maven wrapper, a `pom.xml` with Spring Web and the test
starter, an application class, an `application.yml` with almost nothing in it,
a test that starts the context, and the compose file above.

**Not in here, on purpose:** a database driver, anything that runs schema
migrations, anything that stores short-lived data, anything that sends mail,
anything that validates request bodies.

That is not an oversight. Working out which dependencies you need, adding them
to `pom.xml` and configuring them is a large part of the assignment. Add them
one at a time and run `./mvnw test` after each one — that way when something
stops starting up, you know exactly what caused it.

---

## Configuration and secrets

Anything secret comes from an environment variable, never from a file you
commit:

```yaml
spring:
  mail:
    password: ${MAIL_PASSWORD}
```

Copy `.env.example` to `.env` and put your real values there. `.env` is already
git-ignored — add the ignore rule *before* you create a file, never after.

---

## Submitting

- Fork this repository
- Work on a branch called `feature/registration-otp`
- Open a pull request against your fork's `main` and add your reviewer
- Say in the PR description what you finished and what you didn't — an honest
  "I ran out of time on the resend cooldown" costs you nothing
- Update this README with anything a person needs in order to run your version

There is no grade. You get a code review — a conversation about the choices you
made. Bring the parts you found confusing rather than hiding them; that is
where the value of the week actually is.

---

## Notes

- Java 17 or newer. Check with `java -version`.
- Spring Boot 3.5.0. You can bump the patch version in `pom.xml` if you like.
- Stuck on the same error for ninety minutes? Ask.
