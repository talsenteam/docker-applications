using NUnit.Framework;
using Moq;
using System.Linq;

namespace Cheatsheet
{
    public interface IDatabase
    {
        void Connect();
        string[] Fetch(string query);
    }

    public interface ISystemOutput
    {
        void Print(string message);
    }

    public static class DataPrinter
    {
        public static void PrintData(IDatabase db, ISystemOutput output)
        {
            db.Connect();

            foreach (var name in db.Fetch("select name from persons"))
            {
                output.Print(name);
            }
        }
    }

    public class DataPrinterTests
    {
        [Test]
        public void should_connect_to_database()
        {
            // arrange
            var db = new Mock<IDatabase>();
            var output = new Mock<ISystemOutput>();

            // act
            DataPrinter.PrintData(db.Object, output.Object);            

            // assert
            db.Verify(foo => foo.Connect(), Times.Once());
        }

        [Test]
        public void should_connect_to_database_before_fetching_data()
        {
            // arrange
            var connected = false;
            var db = new Mock<IDatabase>();
            var output = new Mock<ISystemOutput>();
            db.Setup(d => d.Connect()).Callback(() => connected = true);
            db.Setup(d => d.Fetch(It.IsAny<string>())).Callback(() => { if (!connected) Assert.Fail("Fetched before connecting!"); });
            
            // act
            DataPrinter.PrintData(db.Object, output.Object);

            // assert
            db.Verify(foo => foo.Connect());
            db.Verify(foo => foo.Fetch(It.IsAny<string>()));
        }

        [Test]
        public void should_output_fetched_data()
        {
            // arrange
            string[] persons = { "Tom", "Anna", "Simon", "Nina" };
            var db = new Mock<IDatabase>();
            var output = new Mock<ISystemOutput>();
            db.Setup(d => d.Fetch("select name from persons")).Returns(persons.ToArray());

            // act
            DataPrinter.PrintData(db.Object, output.Object);

            // assert
            foreach (var person in persons)
            {
                output.Verify(o => o.Print(person), Times.Once);
            }

            output.VerifyNoOtherCalls();
        }
    }
}
