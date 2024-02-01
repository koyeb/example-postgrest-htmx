-- 04_new.sql

-- Create an endpoint for adding new notes
CREATE OR REPLACE FUNCTION api.add_note(_title text, _content text) RETURNS "text/html" AS $$
  BEGIN
    INSERT INTO api.notes(title, content) VALUES (_title, _content);
    RETURN 'Note added successfully.' AS result;
  EXCEPTION
    WHEN others THEN
      -- An error occurred during the insert operation
      RAISE NOTICE 'An error occurred: %', SQLERRM;
      RETURN 'An error occurred.' AS result;
  END;
$$ LANGUAGE plpgsql;

-- Create page for submitting new notes
CREATE OR REPLACE FUNCTION api.new() RETURNS "text/html" AS $$
  SELECT $html$
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Note Taking App</title>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
      <!-- htmx for AJAX requests -->
      <script src="https://unpkg.com/htmx.org"></script>
    </head>

    <body hx-headers='{"Accept": "text/html"}'>
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="/rpc/index">Note App</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
          aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item">
              <a class="nav-link" href="/rpc/index">Notes</a>
            </li>
            <li class="nav-item active">
              <a class="nav-link" href="/rpc/new">Create Note</a>
            </li>
          </ul>
        </div>
      </nav>

      <div class="container mt-4">
        <h2>Create a New Note</h2>
        <form hx-post="/rpc/add_note" hx-trigger="submit" hx-on="htmx:afterRequest: this.reset()" hx-target="#response-area">
          <p class="text-success" id="response-area"></p>
          <div class="form-group">
            <label for="note-title">Title:</label>
            <input type="text" class="form-control" id="note-title" name="_title" placeholder="Enter note title" required>
          </div>
          <div class="form-group">
            <label for="note-content">Content:</label>
            <textarea class="form-control" id="note-content" name="_content" rows="4" placeholder="Enter note content"
              required></textarea>
          </div>
          <button type="submit" class="btn btn-primary">Save Note</button>
        </form>
      </div>
    </body>
    </html>
  $html$;
$$ language sql;
