# Code Style Guide v1.1

This document outlines the coding standards, style guides, and general principles for the Death Star project. Adherence to these guidelines is enforced automatically by linters in the CI/CD pipeline.

## General Principles

1.  **Clarity over Cleverness:** Code should be easy to read and understand. Avoid overly complex or "clever" solutions if a simpler one exists.
2.  **Don't Repeat Yourself (DRY):** Avoid duplicating code. Use functions, modules, and classes to create reusable components.
3.  **Conventional Commits:** All commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification. This is enforced by `commitlint`.

## Go (Backend)

-   **Formatting:** All Go code is formatted using `gofmt`. This is checked by the `golangci-lint` configuration.
-   **Linting:** We use `golangci-lint` with the rules defined in the `.golangci.yml` file at the root of the `death-star-command-core` repository. Key linters include:
    -   `goimports`: Formats code and manages imports.
    -   `govet`: Analyzes code for suspicious constructs.
    -   `errcheck`: Checks for unhandled errors.
    -   `unused`: Checks for unused code.
-   **Error Handling:** Errors should be handled explicitly. Do not discard errors using the blank identifier (`_`).

## TypeScript/Next.js (Frontend)

-   **Formatting:** All frontend code is formatted using `Prettier`. The configuration is defined in the `.prettierrc` file.
-   **Linting:** We use `ESLint` with the recommended rules for Next.js (`next/core-web-vitals`). The configuration is defined in the `.eslintrc.json` file.
-   **Component Naming:** Components should be named using PascalCase (e.g., `PrimaryButton.tsx`).
-   **State Management:** For global state, use `zustand`. For local state, use React's built-in `useState` and `useReducer` hooks.