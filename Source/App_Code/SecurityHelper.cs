using System;
using System.Security.Cryptography;

public static class SecurityHelper
{
    private const int Iterations = 10000;
    private const int SaltBytes = 16;
    private const int HashBytes = 32;

    public static string HashPassword(string password)
    {
        if (password == null) password = string.Empty;
        byte[] salt = new byte[SaltBytes];
        using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
        }

        byte[] hash = Derive(password, salt, Iterations);
        return "PBKDF2$" + Iterations + "$" + Convert.ToBase64String(salt) + "$" + Convert.ToBase64String(hash);
    }

    public static bool VerifyPassword(string password, string storedPassword)
    {
        if (storedPassword == null) return false;
        if (!storedPassword.StartsWith("PBKDF2$", StringComparison.Ordinal))
        {
            return string.Equals(password, storedPassword, StringComparison.Ordinal);
        }

        string[] parts = storedPassword.Split('$');
        if (parts.Length != 4) return false;

        int iterations;
        if (!int.TryParse(parts[1], out iterations)) return false;

        byte[] salt;
        byte[] expected;
        try
        {
            salt = Convert.FromBase64String(parts[2]);
            expected = Convert.FromBase64String(parts[3]);
        }
        catch
        {
            return false;
        }

        byte[] actual = Derive(password ?? string.Empty, salt, iterations);
        return FixedTimeEquals(actual, expected);
    }

    public static bool IsHashed(string storedPassword)
    {
        return !string.IsNullOrWhiteSpace(storedPassword) && storedPassword.StartsWith("PBKDF2$", StringComparison.Ordinal);
    }

    private static byte[] Derive(string password, byte[] salt, int iterations)
    {
        using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
        {
            return pbkdf2.GetBytes(HashBytes);
        }
    }

    private static bool FixedTimeEquals(byte[] left, byte[] right)
    {
        if (left == null || right == null || left.Length != right.Length) return false;
        int diff = 0;
        for (int i = 0; i < left.Length; i++) diff |= left[i] ^ right[i];
        return diff == 0;
    }
}
