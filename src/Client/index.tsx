import * as React from "react";
import { render } from "react-dom";
import * as GraphiQL from "graphiql/dist/components/GraphiQL.js";
import * as fetch from "isomorphic-fetch";

function graphQLFetcher(graphQLParams) {
  return fetch(window.location.origin + "/graphql", {
    method: "post",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(graphQLParams)
  }).then(response => response.json());
}

//render(<div>hello from gql editor </div>, document.body);

render(<GraphiQL fetcher={graphQLFetcher} />, document.body);
