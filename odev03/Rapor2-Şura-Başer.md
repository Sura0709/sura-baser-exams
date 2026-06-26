Kısa açıklama:
*Ödünç alma işlemi sırasında hem Loans tablosuna kayıt eklenmeli hem de BookCopies tablosundaki kitabın durumu Borrowed olarak güncellenmelidir. Bu iki işlem aynı transaction içinde yapılır çünkü işlemlerden biri başarılı olup diğeri başarısız olursa veritabanında tutarsızlık oluşabilir. Böylece veri bütünlüğü korunmuş olur. 

Tabloların arasındaki ilişkiler:
*Categories tablosu ile Books tablosu arasında bire-çok (1-N) ilişki vardır. Bir kategoriye ait birden fazla kitap bulunabilir.
*Books tablosu ile BookCopies tablosu arasında bire-çok (1-N) ilişki vardır. Bir kitabın birden fazla fiziksel kopyası olabilir.
*Members tablosu ile Loans tablosu arasında bire-çok (1-N) ilişki vardır. Bir üye birden fazla kitap ödünç alabilir.
*BookCopies tablosu ile Loans tablosu arasında bire-çok (1-N) ilişki vardır. Bir kitap kopyası zaman içinde farklı ödünç işlemlerinde kullanılabilir.

Kullanılan Bilgisayar Ortamı:
*Veritabanı Yönetim Sistemi: Microsoft SQL Server
*SQL Arayüzü: SQL Server Management Studio (SSMS)
*Kod Editörü: Visual Studio Code
*Diagram ve Markdown görüntüleme için Mermaid destekli Markdown Preview eklentisini kullandım.