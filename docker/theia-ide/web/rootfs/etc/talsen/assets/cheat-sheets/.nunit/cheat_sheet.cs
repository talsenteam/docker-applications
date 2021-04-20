using NUnit.Framework;

namespace Cheatsheet
{
    public class Printer
    {
        public string Print( )
        {
            return "Hello, world!";
        }

        public string Print( string a_name )
        {
            return $"Hello, {a_name}!";
        }
    }

    public class PrinterTests
    {
        [Test]
        public void simple_test( )
        {
            // Arrange
            const string expected = "Hello, world!";

            var o = new Printer( );

            // Act
            var result = o.Print( );

            // Assert
            Assert.AreEqual( expected, result );
        }

        [TestCase( "Linux", "Hello, Linux!" )]
        [TestCase( "Susan", "Hello, Susan!" )]
        [TestCase( "segfault", "Hello, segfault!" )]
        [TestCase( "Bert", "Hello, Bert!" )]
        public void parameterized_test_using_test_case_labels( string a_input, string a_expected )
        {
            // Arrange
            var expected = a_expected;
            var input    = a_input;

            var o = new Printer( );

            // Act
            var result = o.Print( input );

            // Assert
            Assert.AreEqual( expected, result );
        }

        private static string[][] CreateValues( )
        {
            return new [] {
                new [] { "Linux", "Hello, Linux!" },
                new [] { "Susan", "Hello, Susan!" },
                new [] { "segfault", "Hello, segfault!" },
                new [] { "Bert", "Hello, Bert!" },
            };
        }

        [Test]
        public void parameterized_test_using_value_source_label( [ValueSource("CreateValues")] string[] a_values )
        {
            // Arrange
            var expected = a_values[1];
            var input    = a_values[0];

            var o = new Printer( );

            // Act
            var result = o.Print( input );

            // Assert
            Assert.AreEqual( expected, result );
        }
    }
}