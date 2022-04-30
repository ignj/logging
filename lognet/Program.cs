using Microsoft.AspNetCore.Mvc;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((ctx, lc) => lc.WriteTo.Console());

var app = builder.Build();

app.MapGet("/", ([FromServices] ILogger<Program> logger) =>
{
    while (true)
    {
        logger.LogCritical(new System.Exception(), "TestMessage", "p2");
        Thread.Sleep(5000);
    }
});

app.Run();
