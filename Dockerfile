FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY src/ ./
RUN dotnet restore "CoinDeskWebApiApp/CoinDeskWebApiApp.csproj"

COPY . .
WORKDIR "src/CoinDeskWebApiApp"
RUN dotnet build "CoinDeskWebApiApp.csproj" -c Release --no-restore -o /app/build

# Publish application
FROM build AS publish
RUN dotnet publish "CoinDeskWebApiApp.csproj" -c Release -o /app/publish

# Build runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime-base
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "CoinDeskWebApiApp.dll"]