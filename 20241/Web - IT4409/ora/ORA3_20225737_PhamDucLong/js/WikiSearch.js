const searchTermElem = document.querySelector('#searchTerm');
const searchResultElem = document.querySelector('#searchResult');

searchTermElem.addEventListener('input', function (event) {
  search(event.target.value);
});

const debounce = (fn, delay = 500) => {
  let timeoutId;
  return (...args) => {
    if (timeoutId) {
      clearTimeout(timeoutId);
    }
    timeoutId = setTimeout(() => fn.apply(null, args), delay);
  };
};

const search = debounce(async (searchTerm) => {
  if (!searchTerm) {
    searchResultElem.innerHTML = '';
    return;
  }

  try {
    const url = `https://en.wikipedia.org/w/api.php?action=query&list=search&format=json&origin=*&srlimit=10&srsearch=${searchTerm}`;
    const response = await fetch(url);
    const searchResults = await response.json();
    const searchResultHtml = generateSearchResultHTML(searchResults.query.search, searchTerm);
    searchResultElem.innerHTML = searchResultHtml;
  } catch (error) {
    console.error('Error fetching data from Wikipedia API:', error);
  }
});

const stripHtml = (html) => {
  const div = document.createElement('div');
  div.innerHTML = html;
  return div.textContent || div.innerText || '';
};

const highlight = (text, keyword, className = 'highlight') => {
  const highlightedText = `<span class="${className}">${keyword}</span>`;
  return text.replace(new RegExp(keyword, 'gi'), highlightedText);
};

const generateSearchResultHTML = (results, searchTerm) => {
  return results
    .map(result => {
      const title = highlight(stripHtml(result.title), searchTerm);
      const snippet = highlight(stripHtml(result.snippet), searchTerm);
      return `
        <article>
          <a href="https://en.wikipedia.org/?curid=${result.pageid}" target="_blank">
            <h2>${title}</h2>
          </a>
          <div class="summary">${snippet}...</div>
        </article>
      `;
    })
    .join('');
};
