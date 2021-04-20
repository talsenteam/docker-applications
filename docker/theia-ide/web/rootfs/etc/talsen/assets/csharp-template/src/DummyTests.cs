using NUnit.Framework;

using Application;

namespace ApplicationTests
{
    public class DummyTests
    {
        // Behavior Declaration:
        //   1. Given => Arrange / Pre-Condition
        //   2. When => Act / Execution
        //   3. Then => Assert / Post-Condition
        [Test]
        public void Given_ValidDummy_When_ValueIsRead_Then_CorrectValueIsProvided()
        {
            // Arrange
            const int expectedResult = 8;

            var o = new Dummy();

            // Act
            var result = o.GetValue();

            // Assert
            Assert.AreEqual(expectedResult, result);
            Assert.Ignore();
        }
    }
}
