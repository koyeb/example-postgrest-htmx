-- 03_index.sql

-- Add media type handler for `text/html` requests
CREATE DOMAIN "text/html" AS TEXT;

-- Sanitize text to replace characters with HTML entities
CREATE OR REPLACE FUNCTION api.sanitize_html(text) RETURNS text AS $$
  SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE($1, '&', '&amp;'), '"', '&quot;'),'>', '&gt;'),'<', '&lt;'), '''', '&apos;')
$$ language sql;

-- Format all notes as HTML cards
CREATE OR REPLACE FUNCTION api.html_note(api.notes) RETURNS text AS $$
  SELECT FORMAT($html$
    <div class="card">
      <div class="card-body">
        <h5 class="card-title">%2$s</h5>
        <p class="card-text text-truncate">%3$s</p>
      </div>
    </div>
  $html$,
  $1.id,
  api.sanitize_html($1.title),
  api.sanitize_html($1.content)
  );
$$ language sql stable;

-- Create HTML to display all notes
CREATE OR REPLACE FUNCTION api.html_all_notes() RETURNS text AS $$
  SELECT COALESCE(
    '<div class="card-columns">'
      || string_agg(api.html_note(n), '' ORDER BY n.id) ||
    '</div>',
    '<p class="">No notes.</p>'
  )
  FROM api.notes n;
$$ language sql;

-- Generate page to display notes
CREATE OR REPLACE FUNCTION api.index() RETURNS "text/html" AS $$
  SELECT $html$
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Note Taking App</title>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>

    <body>
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="/rpc/index">Note App</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
          aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item active">
              <a class="nav-link" href="/rpc/index">Notes</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/rpc/new">Create Note</a>
            </li>
          </ul>
        </div>
      </nav>

      <div class="container mt-4">
        <h2>Notes</h2>
        $html$
          || api.html_all_notes() ||
        $html$
      </div>

      <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
  $html$
$$ language sql;
