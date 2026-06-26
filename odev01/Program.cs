namespace Alıştırma_1;

class Program
{
    static void Main(string[] args)
    {
        Member member1 = new Member
            {
                Id = 1,
                FullName = "Şura Başer",
                MonthlyFee = 250.00m,
                Email = "sura.baser@gmail.com",
                JoinDate = new DateTime(2023, 3, 15)
            };
        member1.PrintSummary();

        Member member2 = new Member
            {
                Id = 2,
                FullName = "Dursun Çelik",
                MonthlyFee = 0m,
                Email = "dursun.celik@gmail.com",
                JoinDate = new DateTime(2023, 3, 15)
            };
        member2.PrintSummary();

        Console.WriteLine("\n── Validasyon Testleri ──");

            // Geçersiz FullName
            try
            {
                member1.FullName = "   ";
            }
            catch (ArgumentException ex)
            {
                Console.WriteLine($"[FullName HATA]    {ex.Message}");
            }

            // Geçersiz Email
            try
            {                member1.Email = "geçersiz-email";
            }
            catch (ArgumentException ex)
            {
                Console.WriteLine($"[Email HATA]       {ex.Message}");
            }

            // Geçersiz MonthlyFee
            try
            {                member1.MonthlyFee = -50m;
            }
            catch (ArgumentException ex)
            {
                Console.WriteLine($"[MonthlyFee HATA]  {ex.Message}");
            }
    }



    GymBranch branch1 = new GymBranch
    {
        Id = 1,
        CityName = "Istanbul"
    };
    
    GymBranch branch2 = new GymBranch
    {
        Id = 2,
        CityName = "Ankara"
    };

    GymBranch branch3 = new GymBranch
    {
        Id = 3,
        CityName = "Samsun"
    };

    

}
