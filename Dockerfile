FROM postgrest/postgrest:latest

# Create and set the working directory
WORKDIR /app
ARG PORT

# Set environment variables for PostgREST configuration
ENV PGRST_DB_URI=${PGRST_DB_URI}
ENV PGRST_DB_SCHEMA=${PGRST_DB_SCHEMA}
ENV PGRST_DB_ANON_ROLE=${PGRST_DB_ANON_ROLE}
ENV PGRST_SERVER_PORT=${PORT:-8000}

# Expose the port on which PostgREST will run
EXPOSE ${PORT:-8000}

# Command to run PostgREST when the container starts
CMD ["postgrest"]
