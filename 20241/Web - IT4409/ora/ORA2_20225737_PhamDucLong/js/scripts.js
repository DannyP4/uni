const menuContents = [
  {
    id: "courseInfo",
    title: "Trang chủ",
    type: "admin-menu-left",
    leftMenu: [
      {
        id: "classInfo",
        title: "Thông tin khai giảng",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
          { id: "test2", title: "Test 2", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
          { id: "test3", title: "Test 3", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
          { id: "test4", title: "Test 4", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
        ],
      },
      {
        id: "seminar",
        title: "Thông tin Seminar",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
          { id: "test2", title: "Test 2", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
          { id: "test3", title: "Test 3", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
          { id: "test4", title: "Test 4", type: "admin-contents", content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde aut id accusamus dolore temporibus quisquam laborum, ratione, placeat nulla, quam maiores iure? Laborum in obcaecati dolor tempora sapiente aperiam a?" },
        ],
      },
      {
        id: "company",
        title: "Thông tin công ty quan tâm",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "programSchedule",
        title: "Lịch trình chương trình",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "day1", title: "Ngày 1 - Khai giảng", type: "admin-contents" },
          { id: "day2", title: "Ngày 2 - Seminar", type: "admin-contents" },
          { id: "day3", title: "Ngày 3 - Hoạt động cộng đồng", type: "admin-contents"},
        ],
      },
    ],
  },
  {
    id: "info",
    title: "Thông tin môn học",
    type: "admin-menu-left",
    leftMenu: [
      {
        id: "summaryVN",
        title: "Mô tả tóm tắt học phần (tiếng Việt)",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "overview", title: "Tổng quan", type: "admin-contents" },
          { id: "details", title: "Chi tiết", type: "admin-contents" },
        ],
      },
      {
        id: "summaryEN",
        title: "Mô tả tóm tắt học phần (tiếng Anh)",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "overviewEN", title: "Overview", type: "admin-contents" },
          { id: "detailsEN", title: "Details", type: "admin-contents" },
        ],
      },
      {
        id: "contentVN",
        title: "Nội dung tóm tắt học phần (tiếng Việt)",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "introductionVN", title: "Giới thiệu", type: "admin-contents" },
          { id: "assignmentsVN", title: "Nhiệm vụ" },
        ],
      },
      {
        id: "contentEN",
        title: "Nội dung tóm tắt học phần (tiếng Anh)",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "introductionEN", title: "Introduction", type: "admin-contents" },
          { id: "assignmentsEN", title: "Assignments", type: "admin-contents" },
        ],
      },
      {
        id: "reference",
        title: "Sách tham khảo",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
    ],
  },
  {
    id: "web-tech",
    title: "Các công nghệ Web",
    type: "admin-menu-left",
    leftMenu: [
      {
        id: "frontend",
        title: "1. Frontend (Giao diện người dùng)",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "backend",
        title: "2. Backend (Máy chủ và xử lý dữ liệu)",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "database",
        title: "3. Cơ sở dữ liệu",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "api",
        title: "4. API và Tích hợp dịch vụ",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "devops",
        title: "5. DevOps và Triển khai",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "security",
        title: "6. Bảo mật",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "testing",
        title: "7. Testing và Debugging",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "optimization",
        title: "8. Performance Optimization",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "authentication",
        title: "9. User Authentication & Authorization",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "ux-ui",
        title: "UX/UI Design",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "uxPrinciples", title: "Các nguyên lý UX" },
          { id: "uiTrends", title: "Xu hướng UI" },
        ],
      },
    ],
  },
  {
    id: "student-info",
    title: "Thông tin sinh viên",
    type: "admin-menu-left",
    leftMenu: [
      {
        id: "cv",
        title: "CV",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Name", type: "admin-contents", content: "Phạm Đức Long" },
          { id: "test2", title: "MSSV", type: "admin-contents", content: "20225737" },
          { id: "test3", title: "Ava", type: "admin-contents", content: "<image src='./assets/ava.jpg' alt='Ava' class='profile-photo w3-image' style='width: 100%; max-width: 300px'/>" },
          { id: "test4", title: "Sở thích", type: "admin-contents", content: "Chơi game gacha" },
        ],
      },
      {
        id: "skills-info",
        title: "Các dự án tham gia",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Caffe Management System", type: "admin-contents", content: "Tech: Java, JDBC, Swing, SQLServer ... <br/>Mô tả: Xây dựng app nhằm quản lý doanh thu quán caffe, ngoài ra có các chức năng crud cơ bản và tính năng giảm giá cho khách hàng vào những dịp đặc biệt." },          
          { id: "test2", title: "Book Store Web", type: "admin-contents", content: "Tech: HTML, CSS, JavaScript, Java Servlet, JDBC, SQLServer<br/>Mô tả: Website bán sách online." },          
        ],
      },
      {
        id: "projects-info",
        title: "Hoạt động cộng đồng",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Sinh hoạt công dân", type: "admin-contents", content: "Tham gia các hoạt động sinh hoạt công dân của trường Công nghệ thông tin và truyền thông SOICT nói riêng và của Đại học Bách Khoa Hà Nội nói chung." },
          { id: "test2", title: "Tình nguyện", type: "admin-contents", content: "None" },          
          { id: "test2", title: "CLB", type: "admin-contents", content: "Head of Media GDSC Gen 3, President of YSBK gen 11." },          
        ],
      },            
    ],
  },
  {
    id: "admin-page",
    title: "Admin Page",
    type: "admin-menu-left",
    leftMenu: [
      {
        id: "user-management",
        title: "Trang chủ",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "settings",
        title: "Thông tin môn học",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "logs",
        title: "Các công nghệ web",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "test1", title: "Test 1", type: "admin-contents" },
          { id: "test2", title: "Test 2", type: "admin-contents" },
          { id: "test3", title: "Test 3", type: "admin-contents" },
          { id: "test4", title: "Test 4", type: "admin-contents" },
        ],
      },
      {
        id: "feedback",
        title: "Thông tin sinh viên",
        type: "admin-contents-layout",
        leftMenu: [
          { id: "user-feedback", title: "Phản hồi từ người dùng" },
          { id: "survey", title: "Khảo sát" },
        ],
      },
    ],
  },
];

var mySidebar = document.getElementById("mySidebar");
var overlayBg = document.getElementById("myOverlay");

function w3_open() {
  mySidebar.style.display =
    mySidebar.style.display === "block" ? "none" : "block";
  overlayBg.style.display =
    overlayBg.style.display === "block" ? "none" : "block";
}

function w3_close() {
  mySidebar.style.display = "none";
  overlayBg.style.display = "none";
}

const showContent = (item) => {
  const sections = document.querySelectorAll(".w3-container");
  sections.forEach((section) => section.classList.add("hidden"));

  const buttons = document.querySelectorAll(".w3-bar-item");
  buttons.forEach((button) => button.classList.remove("active"));

  document.getElementById(item.id).classList.remove("hidden");

  const sidebar = document.getElementById("mySidebar");
  sidebar.innerHTML = "";

  const localMenu = menuContents;
  const selectedItem = localMenu.find((menuItem) => menuItem.id === item.id);

  if (selectedItem) {
    showSideBar(selectedItem.leftMenu, selectedItem.title);
  }
};

window.onload = function () {
  const localMenu = menuContents;
  const adminPage = localMenu.find((menuItem) => menuItem.id === "admin-page");
  if (adminPage) showContent(adminPage);
};

const createMenuItem = (href, title, onClick) => {
  const aTag = document.createElement("a");
  aTag.className = "w3-bar-item w3-button w3-hover-black";
  aTag.href = href;
  aTag.textContent = title;
  aTag.onclick = onClick;
  return aTag;
};

const createButton = (title, onClick, className = "") => {
  const button = document.createElement("button");
  button.textContent = title;
  button.onclick = onClick;
  button.className = className;
  return button;
};

const showNavBar = () => {
  let navBar = document.querySelector(".w3-top .w3-bar");
  navBar.innerHTML = "";

  const homeLink = createMenuItem("#", "", () => showContent(menuContents[0]));
  homeLink.innerHTML = "<i class='fas fa-home'></i>";
  navBar.appendChild(homeLink);

  const menuButton = createButton("", w3_open);
  menuButton.innerHTML = "<i class='fa fa-bars'></i>";
  menuButton.classList.add(
    "w3-bar-item",
    "w3-button",
    "w3-right",
    "w3-hide-large",
    "w3-hover-white",
    "w3-large",
    "w3-theme-l1"
  );
  navBar.appendChild(menuButton);

  const localMenu = menuContents;
  localMenu.forEach((item) => {
    if(item.id !== 'courseInfo') {
      const topic = createMenuItem(`#${item.id}`, item.title, () => {
        showContent(item);
        if (item.id === "admin-page") {
          showAdminPageMainContent(menuContents, "Admin Page", null);
        }
      });
      navBar.appendChild(topic); 
    }    
  });
};

const showSideBar = (leftMenu = [], titleSideBar = "") => {
  const sidebar = document.getElementById("mySidebar");
  sidebar.innerHTML = "";

  const title = document.createElement("h4");
  title.classList.add("w3-bar-item");
  title.innerHTML = `<b>${titleSideBar}</b>`;
  sidebar.appendChild(title);

  leftMenu.forEach((subItem) => {
    const aTag = createMenuItem(`#${subItem.id}`, subItem.title, () => {});
    aTag.classList.add("w3-bar-item", "w3-button", "w3-hover-black");
    sidebar.appendChild(aTag);
  });
};

const handleEditItem = (selectedItem, parentArray, title, type) => {
  console.log("EDIT: ", selectedItem, parentArray, title, type);

  const editedItem = prompt("Edit Topic ...", selectedItem.title);

  if (editedItem) {
    selectedItem.title = editedItem;
    localStorage.setItem("menuContents", JSON.stringify(menuContents));
    showAdminPageMainContent(parentArray, title, type);
    showSideBar(parentArray, title);
    showNavBar();

    if (type === "admin-contents") {
      showAdminContentsLayout(parentArray, title);
    }
  }
};

const handleAddItem = (selectedItem, index, parentArray, title, type) => {
  console.log("ADD: ", selectedItem, index, parentArray, title, type);

  const newItemTitle = prompt("Add New Topic ...", "");

  if (newItemTitle) {
    const newItem = {
      title: newItemTitle,
      leftMenu: [
        ],
      type: type == null ? "admin-menu-left" : "admin-contents-layout",
    };

    parentArray.splice(index + 1, 0, newItem);

    localStorage.setItem("menuContents", JSON.stringify(menuContents));

    showAdminPageMainContent(parentArray, title, type);
    showSideBar(parentArray, title);
    showNavBar();

    if (type === "admin-contents") {
      showAdminContentsLayout(parentArray, title);
    }
  }
};

const handleDeleteItem = (selectedItem, index, parentArray, title, type) => {
  const confirmDelete = confirm(
    `Are you sure you want to delete "${selectedItem.title}"?`
  );

  if (confirmDelete) {
    parentArray.splice(index, 1);

    localStorage.setItem("menuContents", JSON.stringify(menuContents));

    showAdminPageMainContent(parentArray, title, type);
    showSideBar(parentArray, title);
    showNavBar();

    if (type === "admin-contents") {
      showAdminContentsLayout(parentArray, title);
    }
  }
};

const showAdminContentsLayout = (selectedItem, title) => {
  const mainContent = document.querySelector("#admin-page");
  const div = document.createElement("div");

  let width = 75;

  div.className = "container w3-padding";
  div.innerHTML = `    
    <div class="w3-pale-yellow w3-round w3-margin w3-padding-16 w3-center">
      <button class="w3-bar-item w3-button w3-right"><i class='fas fa-question-circle'></i></button>
      <h4 class="header" style="margin: 0 !important">${title}</h4>
    </div>    
    <div class="w3-cell-row">
      <input type="range" id="widthSlider" min="0" max="100" value="${width}" style="width: 100%">
    </div>
    <div class="w3-cell-row"> 
      <div class="w3-container w3-cell" style="padding: 0; width: ${width}%"></div>
      <div class="w3-container w3-cell" style="padding: 0; width: calc(100% - ${width}%)"></div>
    </div>
  `;

  div.firstElementChild.firstElementChild.addEventListener("click", () => {
    alert("Kéo slide để thay đổi layout tương ứng");
  });

  const updateWidths = (newWidth) => {
    div.querySelectorAll(".w3-cell")[0].style.width = `${newWidth}%`;
    div.querySelectorAll(
      ".w3-cell"
    )[1].style.width = `calc(100% - ${newWidth}%)`;
  };

  const widthSlider = div.querySelector("#widthSlider");
  widthSlider.addEventListener("input", (event) => {
    const newWidth = event.target.value;
    updateWidths(newWidth);
  });

  selectedItem.forEach((subItem, i) => {
    const heading = document.createElement("div");
    heading.className = "w3-border w3-round-small w3-padding-large w3-large";
    heading.innerHTML = `
      <h3>${subItem.title}</h3>
      <p>${subItem.content}</p>      
    `;

    if (i % 2 === 0) {
      div.lastElementChild.firstElementChild.appendChild(heading);
    } else {
      div.lastElementChild.lastElementChild.appendChild(heading);
    }
  });

  mainContent.appendChild(div);
};

const showAdminContents = (item) => {  
  const form = document.querySelector("#myForm");
  form.classList.remove("hidden");
  form.nextElementSibling.remove();  

  document.querySelector('#editor').textContent = item.content;

  init();

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const editorData = document.querySelector(`[role="textbox"]`).innerHTML;    
    console.log(editorData);
    const div = document.createElement('div');
    div.className = "container w3-margin-top";

    div.innerHTML = `
      <div class="header w3-border-bottom">${item.title}</div>
      <div>
        <p>${editorData}</p>
      </div>
    `;

    item.content = editorData;

    if(!form.nextElementSibling) {
      form.parentElement.append(div);    
    } else {
      form.nextElementSibling.replaceWith(div);
    }
  });
};

const showAdminPageMainContent = (selectedItem, title, type) => {
  console.log("MAIN: ", selectedItem, title, type);  

  const container = document.querySelectorAll("#admin-page .container");
  if(container.length == 0 || container[0].className === "container w3-margin-top") {
    document.querySelector("#admin-page").innerHTML = `
      <form id="myForm" method="post" class="hidden">
        <div id="editor" style="height: 200px;">Hello</div> <!-- This will be the Quill editor container -->
        <button type="submit" class="w3-button w3-blue w3-padding-large w3-round">Submit</button>
      </form>
      <div class="container">
        <div class="w3-center">
          Admin menu top: Chỉnh sưa menu top          
        </div>
        <ul class="menu-list-contents">

        </ul>
      </div>      
    `;
    init();
  }

  if (container.length > 1) {
    container[1].remove();
  }

  const ul = document.querySelector("#admin-page .container ul");
  
  ul.previousElementSibling.innerHTML = `
    <span class="header">${type == null ? "" : type.split("-").join(" ").toUpperCase() + ": "} ${title} </span>
    <button class="header w3-button w3-round" style="margin-bottom: 8px" id="add-btn">
      <i class="fas fa-plus"></i>
    </button>
  `;

  ul.previousElementSibling.lastElementChild.addEventListener("click", () => {
    handleAddItem(null, -1, selectedItem, title, type);
  });

  ul.innerHTML = "";

  selectedItem?.forEach((item, i) => {
    if (item.title !== "Admin Page") {
      const li = document.createElement("li");
      li.innerHTML = `
        <span class="w3-bold w3-large">${item.title}</span>
        <span class="action">
          <button class="w3-button w3-blue w3-round w3-hover-shadow"><i class="fas fa-eye"></i> View</button>
          <button class="w3-button w3-green w3-round w3-hover-shadow"><i class="fas fa-edit"></i> Edit</button>
          <button class="w3-button w3-teal w3-round w3-hover-shadow"><i class="fas fa-plus"></i> Add</button>
          <button class="w3-button w3-red w3-round w3-hover-shadow"><i class="fas fa-trash"></i> Delete</button>
        </span>
      `;

      const btnsAction = li.querySelectorAll("button");
      btnsAction.forEach((btn, idx) => {
        if(item.id === 'courseInfo' && (idx === 1 || idx === 3)) {
          btn.style.display = "none";
        }

        btn.addEventListener("click", () => {
          switch (idx) {
            case 0:
              console.log("VIEW: ", item);
              showSideBar(item.leftMenu, item.title);
              showAdminPageMainContent(item?.leftMenu, item.title, item.type);
              if (type === "admin-menu-left") {
                showAdminContentsLayout(item?.leftMenu, item.title);
              } else if (type === "admin-contents-layout") {
                showAdminContents(item);
              }
              break;
            case 1:
              handleEditItem(item, selectedItem, title, item.type);
              break;
            case 2:
              handleAddItem(item, i, selectedItem, title, item.type);
              break;
            case 3:
              handleDeleteItem(item, i, selectedItem, title, item.type);
              break;
          }
        });
      });

      ul.appendChild(li);
    }
  });

  if(title === "Thông tin sinh viên") {
    const btn = createButton("", () => {
      location.reload();
    }, "header w3-button w3-round");
    btn.innerHTML = `
       <i class="fas fa-redo"></i>
    `
    btn.style.marginBottom = "8px";
    document.querySelector("#admin-page .container .w3-center").appendChild(btn);
  }

  if(title === "Admin Page") {
    document.querySelector("#add-btn").classList.add('hidden');
  }
};

const init = () => {
  ClassicEditor.create(document.querySelector("#editor"))
  .then((editor) => {
    console.log(editor);
  })
  .catch((error) => {
    console.error(error);
  });
}

showAdminPageMainContent(menuContents, "Admin Page", null);
showNavBar();