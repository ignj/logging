using Microsoft.AspNetCore.Mvc;
using Serilog;
using Serilog.Formatting.Elasticsearch;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((ctx, lc) => lc.WriteTo.Console(new ElasticsearchJsonFormatter() { }));

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
