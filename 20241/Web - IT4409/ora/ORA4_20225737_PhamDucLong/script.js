const CLIENT_ID =
  "202539813668-kb5f268ood843flbueejmvu22jf5bp5k.apps.googleusercontent.com";

const REDIRECT_URI = "http://localhost/20225737/gmail.html";
const SCOPE = "https://mail.google.com/";
// "https://www.googleapis.com/auth/gmail.readonly" +
// " " +
// "https://www.googleapis.com/auth/gmail.send";
// const apiKey = "AIzaSyB0f9oD0ceRh_FyQsRHmbc-Sj1RZAY7bxA";
const titl = document.querySelector(".title");
const signIn = document.querySelector(".login-btn");

const sign_in = function () {
  let oauthen2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";
  let form = document.createElement("form");
  form.setAttribute("method", "GET");
  form.setAttribute("action", oauthen2Endpoint);

  let params = {
    client_id: CLIENT_ID,
    redirect_uri: REDIRECT_URI,
    response_type: "token",
    scope: SCOPE,
    include_granted_scopes: "true",
    state: "pass-through value",
  };
  for (let p in params) {
    let input = document.createElement("input");
    input.setAttribute("type", "hidden");
    input.setAttribute("name", p);
    input.setAttribute("value", params[p]);
    form.appendChild(input);
  }

  // Add form to page and submit it to open the OAuth 2.0 endpoint.
  document.body.appendChild(form);
  form.submit();
  // localStorage.setItem("isLoggedIn", isLoggedIn);
};
signIn.addEventListener("click", sign_in);
