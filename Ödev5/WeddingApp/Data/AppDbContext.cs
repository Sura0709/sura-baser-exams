using Microsoft.EntityFrameworkCore;
using WeddingApp.Models;

namespace WeddingApp.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<RsvpResponse> RsvpResponses => Set<RsvpResponse>();
}
