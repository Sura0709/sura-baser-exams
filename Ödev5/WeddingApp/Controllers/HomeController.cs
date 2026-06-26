using Microsoft.AspNetCore.Mvc;
using WeddingApp.Models;

namespace WeddingApp.Controllers;

public class HomeController : Controller
{
    private readonly IConfiguration _configuration;

    public HomeController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public IActionResult Index()
    {
        SetWeddingViewBag();
        return View();
    }

    public IActionResult Davetiye()
    {
        return RedirectToAction(nameof(Index));
    }

    private void SetWeddingViewBag()
    {
        ViewBag.SiteName = _configuration["SiteName"];
        ViewBag.CoupleNames = _configuration["Wedding:CoupleNames"];
        ViewBag.Date = _configuration["Wedding:Date"];
        ViewBag.Venue = _configuration["Wedding:Venue"];
        ViewBag.Address = _configuration["Wedding:Address"];
        ViewBag.ContactEmail = _configuration["Wedding:ContactEmail"];
        ViewBag.WelcomeMessage = _configuration["Wedding:WelcomeMessage"];
    }
}
