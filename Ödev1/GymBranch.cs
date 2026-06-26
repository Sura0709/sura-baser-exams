using System;

namespace Alıştırma_1;

public class GymBranch
{
    public int Id { get; set; }
    public string? CityName { get; set; }

    public void DisplayInfo()
    {
        Console.WriteLine($"Gym Branch ID: {Id}, City: {CityName}");
    }
}
