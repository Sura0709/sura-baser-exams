using System;

namespace Alıştırma_1;

public class Member
{
    public int? Id { get; set; }
    private string? fullName;
    private string? email { get; set; }
    private decimal? monthlyFee { get; set; }
    public DateTime? JoinDate { get; set; }

    public string FullName
    {
        get { return fullName; }
        set
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                throw new ArgumentException("FullName boş veya yalnızca boşluk olamaz.");
                
            }
            fullName = value.Trim();
        }
    }
    public string? Email
    {
        get { return email; }
        set
        {
            if (!string.IsNullOrWhiteSpace(value) && !value.Contains("@"))
            {
                throw new ArgumentException("Geçersiz e-posta adresi.");
            }
            email = value?.Trim();
        }
    }

    public decimal? MonthlyFee
    {
        get { return monthlyFee; }
        set
        {
            if (value < 0)
            {
                throw new ArgumentException("MonthlyFee negatif olamaz.");
            }
            monthlyFee = value;
        }
    }

    public Member()
    {
        Id = 0;
        fullName = "Belirtilmemiş";
        email = "Belirtilmemiş";
        monthlyFee = 0m;
        JoinDate = null;
        Console.WriteLine("Yeni bir üye oluşturuldu.");
    }
    public Member(int id, string fullName) : this()
    {
        Id = id;
        FullName = fullName;
    }

    public Member(int id, string fullName, decimal monthlyFee) : this(id, fullName)
    {
        MonthlyFee = monthlyFee;
    }

    public Member(int id, string fullName, decimal monthlyFee, string email) : this(id, fullName, monthlyFee)
    {
        Email = email;
        JoinDate = DateTime.Now;
    }
    public decimal CalculateQuarterlyCost()
    {
        return (MonthlyFee ?? 0m) * 3;
    }

    public decimal CalculateQuarterlyCost(decimal discountRate)
    {
        if (discountRate < 0 || discountRate > 1)
          throw new ArgumentException("Discount rate must be between 0 and 1.");
        decimal gross = CalculateQuarterlyCost();
        decimal discount = gross * discountRate;
        return gross - discount;
    }

    public string GetFullName()
    {
        return fullName ?? "Belirtilmemiş";
    }
    public bool IsFeeValid => monthlyFee > 0;
    public decimal YearlyEstimate => (decimal)(monthlyFee * 12);
    public int DaysSinceJoined => (DateTime.Today - JoinDate.Value.Date).Days;
    
    public bool IsActiveMember()
        {
            return !string.IsNullOrWhiteSpace(GetFullName()) && MonthlyFee > 0;
        }

    public void PrintSummary()
        {
            Console.WriteLine("─────────────────────────────");
            Console.WriteLine($"  Üye ID      : {Id}");
            Console.WriteLine($"  Ad Soyad    : {GetFullName()}");
            Console.WriteLine($"  E-posta     : {Email ?? "Belirtilmemiş"}");
            Console.WriteLine($"  Aylık Ücret : {MonthlyFee:C2}");   // para birimi formatı
            Console.WriteLine($"  Durum       : {(IsActiveMember() ? " Aktif" : " Pasif")}");
            Console.WriteLine($"  Katılım Tarihi : {JoinDate?.ToString("dd.MM.yyyy") ?? "Belirtilmemiş"}");
            Console.WriteLine("─────────────────────────────");
        }

    internal static object SetFullName(string v)
    {
        throw new NotImplementedException();
    }
}





