//  https://stackoverflow.com/questions/24868273/run-a-c-sharp-cs-file-from-a-powershell-script
namespace myCSharpDemo
{    
    public class BasicTest
    {
        public static int Add(int a, int b)
        {
            return (a + b);
        }

        public int Multiply(int a, int b)
        {
            return (a * b);
        }

        public static string TemplateDemo(string aFriend)
        {
            return ($"Hello {aFriend}");
        }
    }
}

// string aFriend = "Bill";
// Console.WriteLine("Hello " + aFriend);
// Console.WriteLine("Alternatively, you can use 'String Interpolation' (aka, 'Template Strings')");
// Console.WriteLine($"Hello {aFriend}");