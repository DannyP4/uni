const API_KEY = "AIzaSyBYlAcEjIN_zlUDagNgA3mt0tMnjujJsYg";
const CLIENT_ID =
  "202539813668-kb5f268ood843flbueejmvu22jf5bp5k.apps.googleusercontent.com";

  const SCOPE =
  "https://www.googleapis.com/auth/gmail.readonly " +
  "https://www.googleapis.com/auth/gmail.send";

const nameInfo = document.querySelector(".name");
const imgUser = document.querySelector(".img-user");

const btnLogout = document.querySelector(".logout");
const btnComposeEmail = document.querySelector(".compose-mail");
const btnSendEmail = document.querySelector(".send-btn");
const btnCloseModal = document.querySelector(".btn--close-modal");

const dateEmail = document.querySelector(".date");
const formEmail = document.querySelector(".form-mail");
const toEmail = document.querySelector(".to-email");
const subjectEmail = document.querySelector(".subject");
const contentEmail = document.querySelector(".content");
const sender = document.querySelector(".sender");
const listEmail = document.querySelector(".list-email");
const modal = document.querySelector(".modal");
const overlay = document.querySelector(".overlay");
const detailsEmail = document.querySelector(".details-email");
const containerEmail = document.querySelector(".container-email");
const newEmail = document.querySelector(".new-mail");

const toInput = document.querySelector(".to-input");
const subjectInput = document.querySelector(".subject-input");
const textInput = document.querySelector(".text-input");
const nameInput = document.querySelector(".name-input");

const file = document.querySelector(".image-file");

const openModal = function (e) {
  e.preventDefault();
  modal.classList.remove("hidden");
  overlay.classList.remove("hidden");
};

const closeModal = function () {
  modal.classList.add("hidden");
  overlay.classList.add("hidden");
};

let params = {};
let regex = /([^&=]+)=([^&]*)/g,
  m;

while ((m = regex.exec(location.href))) {
  params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
}

if (Object.keys(params).length > 0) {
  localStorage.setItem("authInfo", JSON.stringify(params));
}

window.history.pushState({}, document.title, "/" + "gmail.html");

let info = JSON.parse(localStorage.getItem("authInfo"));
const ACCESS_TOKEN = info["access_token"];



function logout() {
  fetch("https://oauth2.googleapis.com/revoke?token=" + ACCESS_TOKEN, {
    method: "POST",
    headers: {
      "Content-type": "application/x-www-form-urlencoded",
    },
  }).then((data) => {
    location.href = "https://localhost/20225737";
  });
  localStorage.removeItem("authInfo");
}
btnLogout.addEventListener("click", logout);


function base64DecodeUnicode(base64) {
  const decoded = atob(base64);
  const charList = Array.from(decoded, (char) =>
    String.fromCharCode(char.charCodeAt(0))
  );
  return charList.join("");
}
function decodeBase64(encodedString) {
  const normalizedBase64 = encodedString.replace(/-/g, "+").replace(/_/g, "/");
  return base64DecodeUnicode(normalizedBase64);
}

//////////////////////////////////////////////////////////////////////////
// GET LIST EMAIL
fetch(`https://gmail.googleapis.com/gmail/v1/users/me/messages`, {
// fetch(`https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=20`, {
  method: "GET",
  headers: { Authorization: `Bearer ${ACCESS_TOKEN}` },
})
  .then((data) => data.json())
  .then((info) => {
    Array.from(info.messages).forEach((mess) => {
      fetch(
        `https://gmail.googleapis.com/gmail/v1/users/me/messages/${mess.id}?format=full`,
        {
          method: "GET",
          headers: { Authorization: `Bearer ${ACCESS_TOKEN}` },
        }
      )
        .then((data) => data.json())
        .then((email) => {
          // get full message base 64
          let fullMessage;
          if (email.payload.parts) {
            fullMessage = email.payload.parts[0].body.data;
          } else {
            fullMessage = email.payload.body.data;
          }
          const trimmedMessage = fullMessage.trim();
          // Decode the message data
          let decodedMessage;
          try {
            decodedMessage = decodeBase64(trimmedMessage);
          } catch (error) {
            console.error("Error decoding base64:", error);
            return;
          }

          const decoder = new TextDecoder("utf-8"); // Replace 'utf-8' with the appropriate character encoding if needed
          const vietnameseText = decoder.decode(
            new Uint8Array([...decodedMessage].map((c) => c.charCodeAt(0)))
          );
          messageData = {
            id: email.id,
            msg: email.snippet,
          };
          // object contain message information
          let results = {};
          Array.from(email.payload.headers).forEach((message) => {
            if (message.name == "Date") {
              results.date = message.value;
            } else if (message.name == "Subject") {
              results.subject = message.value;
            } else if (message.name == "From") {
              results.from = message.value;
            } else if (message.name == "To") {
              results.to = message.value;
            }
          });
          // render list message
          time = results.date.split(" ");
          const rowMess = document.createElement("tr");
          rowMess.className = "email";
          rowMess.id = `${messageData.id}`;
          rowMess.innerHTML = `
          <tr>
          <td class="sender" id=${messageData.id}>${results.from}</td>
          <td class="subject"id=${messageData.id}>${results.subject}</td>
          <td class="date" id=${messageData.id}>${
            time[4] + "  " + time[1] + " " + time[2] + " " + time[3]
          }</td>
          
          </tr>
          `;
          listEmail.after(rowMess);

          // see email details
          document.querySelector(".email").addEventListener(
            "click",
            // openModal
            function (e) {
              if (e.target.id == email.id) {
                openModal(e);
                if (results.to.split(" ").length > 1) {
                  results.to =
                    results.to.split(" ")[results.to.split(" ").length - 1];
                }
                len = results.to.length;

                timeDetail = results.date.split(" ");
                detailsEmail.innerHTML = `
                <button class="btn--close-modal">&times;</button>
                <div class="subject-details">${results.subject}</div>
                <div class="email-header">
                <div class="address">
                <div class="from-details">
                ${results.from}
                </div>
                <div class="to-details">to ${
                  results.to.includes("<")
                    ? results.to.slice(1, len - 1)
                    : results.to
                }</div>
                </div>
                <div class="date-details" id=${messageData.id}>${
                  timeDetail[4] +
                  ", " +
                  timeDetail[1] +
                  " " +
                  timeDetail[2] +
                  " " +
                  timeDetail[3]
                }</div>
                 </div>
                <div class="container-email">
                <p class="content-details">
                    ${vietnameseText}
                </p>
                </div>
                 `;
                document
                  .querySelector(".btn--close-modal")
                  .addEventListener("click", closeModal);
              }
            }
          );
        });
    });
  });
// compose new email
btnComposeEmail.addEventListener("click", function (e) {
  e.preventDefault();
  newEmail.classList.remove("hidden");
  overlay.classList.remove("hidden");
});
// close modal tạo email
btnCloseModal.addEventListener("click", function (e) {
  e.preventDefault();
  newEmail.classList.add("hidden");
  overlay.classList.add("hidden");
  formEmail.reset();
});
// SEND EMAIL
///////////////////////////////////////////////////////////
const emailData = {};
// load file
const showFile = function () {
  let file = document.getElementById("file").files[0];
  let reader = new FileReader();
  reader.onload = function (e) {
    emailData.file = e.target.result.split(",")[1];
    emailData.fileName = file.name;
  };
  if (file && file.type.match("image.*")) {
    reader.readAsDataURL(file);
  }
};
file.addEventListener("change", showFile);
//////////////////////////////////////////////////
fetch("https://gmail.googleapis.com/gmail/v1/users/me/profile", {
  headers: {
    Authorization: `Bearer ${ACCESS_TOKEN}`,
  },
})
  .then((data) => data.json())
  .then((info) => {
    nameInfo.innerHTML = `Xin chào, ${info.emailAddress}`;

    const sendEmail = async () => {
      emailData.to = toInput.value;
      emailData.subject = subjectInput.value;
      emailData.message = textInput.value;

      // encode subject to base64
      const encodedSubject = btoa(
        unescape(encodeURIComponent(emailData.subject))
      );
      // encode subject to vietnamese
      const base64EncodedSubject = `=?UTF-8?B?${encodedSubject}?=`;
      // file attachment
      const attachment = emailData.file
        ? "Content-Type: image/jpeg\r\n" +
          "Content-Disposition: attachment; filename=" +
          emailData.fileName +
          "\r\n" +
          "Content-Transfer-Encoding: base64\r\n\r\n" +
          emailData.file +
          "\r\n" +
          "--boundary_example\r\n"
        : " ";

      const base64EncodedEmail = btoa(
        unescape(
          encodeURIComponent(
            `From: ${info.emailAddress}\r\n` +
              "To: " +
              emailData.to +
              "\r\n" +
              "Subject: " +
              base64EncodedSubject +
              "\r\n" +
              "Content-Type: multipart/mixed; boundary=boundary_example\r\n\r\n" +
              "Content-Type: text/plain; charset=utf-8\r\n\r\n" +
              "--boundary_example\r\n" +
              emailData.message +
              "\r\n" +
              "--boundary_example\r\n" +
              attachment
          )
        )
      );
      // fetch API send email
      const response = await fetch(
        "https://gmail.googleapis.com/gmail/v1/users/me/messages/send",
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${ACCESS_TOKEN}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            raw: base64EncodedEmail,
          }),
        }
      );

      if (response.ok) {
        alert(`Gửi email thành công đến: ${toInput.value}.`);
      } else {
        alert("Gửi email chưa thành công!");
      }
      // console.log(attachment);
    };

    btnSendEmail.addEventListener("click", sendEmail);
  });
