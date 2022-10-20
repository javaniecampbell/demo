FROM microsoft/mssql-server-linux
COPY /scripts/authentication.batch.sql .
COPY /scripts/business.customers.batch.sql .
COPY /scripts/shoppingcart.batch.sql .
COPY /scripts/history.batch.sql .
EXPOSE 1433

ARG PASSWORD
ENV ACCEPT_EULA Y
ENV SA_PASSWORD ${PASSWORD}

RUN /opt/mssql/bin/sqlservr --accept-eula & sleep 65 \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PASSWORD} -d master -i authentication.batch.sql -I \
    && pkill sqlservr

RUN /opt/mssql/bin/sqlservr --accept-eula & sleep 85 \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PASSWORD} -d master -i business.customers.batch.sql -I \
    && pkill sqlservr

RUN /opt/mssql/bin/sqlservr --accept-eula & sleep 105 \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PASSWORD} -d master -i shoppingcart.batch.sql -I \
    && pkill sqlservr

RUN /opt/mssql/bin/sqlservr --accept-eula & sleep 135 \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${PASSWORD} -d master -i history.batch.sql -I \
    && pkill sqlservr

# RUN ["/opt/mssql-tools/bin/sqlcmd","-i","authentication.batch.sql"]
# RUN ["sqlcmd","-1","history.batch.sql"]


