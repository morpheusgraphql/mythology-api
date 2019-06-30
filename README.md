# Mythology GraphQL API

GraphQL APIs of ancient Greek mythology build with Morpheus GraphQL and Haskell

### Setup

## serverless ofline

As Morpheus is quite new, make sure stack can find morpheus-graphql by running `stack update`

```
npm i
npm start

```

after that, you cent check it out on `http://localhost:3000/`

```GraphQL
query GetDeity {
  deity (name: "Morpheus") {
    fullname
    power
  }
}
```

our query will be resolved!

```JSON
{
  "data": {
    "deity": {
      "fullname": "Morpheus",
      "power": "Shapeshifting"
    }
  }
}
```

## Online Example

Mythology API is deployed on : [_api.morpheusgraphql.com_](https://api.morpheusgraphql.com) where you can test it with `GraphiQL`

## About

### Morpheus GraphQL

Build GraphQL APIs with your favourite functional language!

Morpheus GraphQL helps you to build GraphQL APIs in Haskell with native haskell types.
Morpheus will convert your haskell types to a GraphQL schema and all your resolvers are just native Haskell functions.

Morpheus is still in an early stage of development, so any feedback is more than welcome, and we appreciate any contribution!
Just open an issue here on GitHub, or join [our Slack channel](https://morpheus-graphql-slack-invite.herokuapp.com/) to get in touch.

## Roadmap

- Medium future:
  - Fill content with Greek mythology
- Long term:
  - Support of other mythologies
