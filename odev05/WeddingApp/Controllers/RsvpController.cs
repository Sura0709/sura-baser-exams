using Microsoft.AspNetCore.Mvc;
using WeddingApp.Data;
using WeddingApp.Models;

namespace WeddingApp.Controllers;

public class RsvpController : Controller
{
    private readonly AppDbContext _context;

    public RsvpController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public IActionResult Create()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Create(RsvpResponse model)
    {
        if (!ModelState.IsValid)
        {
            return View(model);
        }

        model.CreatedAt = DateTime.UtcNow;
        _context.RsvpResponses.Add(model);
        await _context.SaveChangesAsync();

        return RedirectToAction(nameof(ThankYou));
    }

    public IActionResult ThankYou()
    {
        return View();
    }
}
