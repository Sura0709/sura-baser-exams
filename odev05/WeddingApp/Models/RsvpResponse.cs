using System.ComponentModel.DataAnnotations;

namespace WeddingApp.Models;

public class RsvpResponse
{
    public int Id { get; set; }

    [Required(ErrorMessage = "Ad alanı zorunludur.")]
    [Display(Name = "Ad")]
    public string FirstName { get; set; } = string.Empty;

    [Required(ErrorMessage = "Soyad alanı zorunludur.")]
    [Display(Name = "Soyad")]
    public string LastName { get; set; } = string.Empty;

    [Required(ErrorMessage = "E-posta alanı zorunludur.")]
    [EmailAddress(ErrorMessage = "Geçerli bir e-posta adresi girin.")]
    [Display(Name = "E-posta")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Telefon alanı zorunludur.")]
    [Phone(ErrorMessage = "Geçerli bir telefon numarası girin.")]
    [Display(Name = "Telefon")]
    public string Phone { get; set; } = string.Empty;

    [Required(ErrorMessage = "Kişi sayısı zorunludur.")]
    [Range(1, 20, ErrorMessage = "Kişi sayısı 1 ile 20 arasında olmalıdır.")]
    [Display(Name = "Kaç kişi katılacak?")]
    public int GuestCount { get; set; }

    [Required(ErrorMessage = "Yemek tercihi seçiniz.")]
    [Display(Name = "Yemek tercihi")]
    public bool? WillAttendMeal { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
