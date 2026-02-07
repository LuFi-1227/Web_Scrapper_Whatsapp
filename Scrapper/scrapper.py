def web_search(query, number_of_results, verbose=False):
    from ddgs import DDGS

    notices = []
    with DDGS() as ddgs:
        base_query = f"notícias {query} Brasil"
        sites = [
            "g1.globo.com",
            "globo.com",
            "estadao.com.br",
            "folha.uol.com.br",
            "cnnbrasil.com.br",
            "bbc.com/portuguese",
            "uol.com.br",
            "terra.com.br"
        ]
        site_filter = " OR ".join(f"site:{s}" for s in sites)
        final_query = f"{base_query} ({site_filter})"

        results = ddgs.text(
            final_query,
            region="br-pt",
            safesearch="off",
            timelimit="d",         # notícias do dia
            max_results=number_of_results
        )

        for r in results:
            notices.append({
                "title": r["title"],
                "href": r["href"],
                "body": r["body"]
            })

            if verbose:
                print(r["title"])
                print(r["href"])
                print(r["body"])
                print("-" * 40)
    return notices

def clear_notice(url):
    try:
        from newspaper import Article
        art = Article(url, language="pt")
        art.download()
        art.parse()
        return art.text
    except:
        from readability import Document
        import requests
        from bs4 import BeautifulSoup

        html = get_html(url)
        doc = Document(html)
        soup = BeautifulSoup(doc.summary(), "html.parser")
        return soup.get_text("\n", strip=True)

def get_html(url):
    import requests
    headers = {"User-Agent": "Mozilla/5.0"}
    return requests.get(url, headers=headers, timeout=10).text

def extract_date_from_html(html):
    from bs4 import BeautifulSoup
    soup = BeautifulSoup(html, "html.parser")

    meta_props = [
        {"property": "article:published_time"},
        {"name": "pubdate"},
        {"name": "date"},
        {"itemprop": "datePublished"}
    ]

    for prop in meta_props:
        tag = soup.find("meta", prop)
        if tag and tag.get("content"):
            return tag["content"]

    return None

def extract_date_from_text(soup):
    import re
    DATE_REGEX = r'(\d{1,2}\s+de\s+\w+\s+de\s+\d{4})'
    text = soup.get_text(" ", strip=True)
    match = re.search(DATE_REGEX, text, re.IGNORECASE)
    return match.group(1) if match else None

def extract_date(url):
    from bs4 import BeautifulSoup
    html = get_html(url)
    date = extract_date_from_html(html)
    if date:
        return date

    soup = BeautifulSoup(html, "html.parser")
    return extract_date_from_text(soup)

def scrapper(notices, verbose=False):
    results = []
    for notice in notices:
        content = clear_notice(notice["href"])
        date = extract_date(notice["href"])
        results.append({
            "title": notice["title"],
            "url": notice["href"],
            "date": date,
            "body": content
        })
        if verbose:
            print(notice["title"])
            print(notice["href"])
            print(notice["body"])
            print(date)
            print("-"*40)
            print(content)
            print("-" * 40)
    return results

def search_and_scrap(query, number_of_results, verbose=False):
    notices = web_search(query, number_of_results)
    response = scrapper(notices, True)
    for r,n in zip(response, notices):
        r["summary"] = n["body"]
        if verbose:
            print(n["title"])
            print(n["href"])
            print(n["body"])
            print("-"*40)
            print(r["body"])
            print("-" * 40)
    
    return response

from flask import Flask, request, jsonify, Response
import json

app = Flask(__name__)
app.config["JSON_AS_ASCII"] = False


@app.route("/", methods=["GET"])
def index():
    query = request.args.get("query")
    number_of_results = request.args.get("number_of_results", type=int, default=5)

    if not query:
        return jsonify({"error": "Parâmetro 'query' é obrigatório"}), 400

    response = search_and_scrap(query, number_of_results)
    return Response(
        json.dumps(response, ensure_ascii=False),
        content_type="application/json; charset=utf-8"
    )

app.run(host="localhost", port=5000, debug=True)

        