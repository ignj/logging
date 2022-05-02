using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Serilog;
using Serilog.Formatting.Elasticsearch;

var builder = WebApplication.CreateBuilder(args);

// https://docs.microsoft.com/en-us/dotnet/core/extensions/console-log-formatter
builder.Host.ConfigureLogging(builder =>
        builder.AddJsonConsole(options =>
        {
            options.IncludeScopes = false;
            options.TimestampFormat = "hh:mm:ss ";
            options.JsonWriterOptions = new JsonWriterOptions
            {
                Indented = true
            };
        }));
// .UseSerilog((ctx, lc) => lc.WriteTo.Console(new ElasticsearchJsonFormatter() { }));

var app = builder.Build();

app.MapGet("/", ([FromServices] ILogger<Program> logger) =>
{
    while (true)
    {
        logger.LogCritical(new System.Exception(), "Some error message", $"Timestamp {DateTime.UtcNow} ErrorId {Guid.NewGuid()}");
        Thread.Sleep(5000);
    }
});

app.Run();
