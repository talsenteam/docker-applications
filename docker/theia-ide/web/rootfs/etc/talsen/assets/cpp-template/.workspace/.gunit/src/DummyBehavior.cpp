
#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "Dummy.hpp"

// Behavior Declaration:
//   1. Given => Arrange / Pre-Condition
//   2. When => Act / Execution
//   3. Then => Assert / Post-Condition
TEST( DummyBehavior, Given_ValidDummy_When_ValueIsRead_Then_CorrectValueIsProvided )
{
    // Arrange
    constexpr int EXPECTED_VALUE = 8;

    Dummy o { };

    // Act
    auto result = o.get_value();

    // Assert
    GTEST_ASSERT_EQ(EXPECTED_VALUE, result);
    GTEST_SKIP();
}

/* // Ignore the code below until you duplicated a test at least 3 times

namespace
{
    struct TestParameter
    {
        int INPUT;
        float EXPECTED_RESULT;
    };

    std::ostream& operator<< (std::ostream& stream, const TestParameter& parameter) {
        return stream <<
            "int: " << parameter.INPUT << " " <<
            "float: " << parameter.EXPECTED_RESULT << "f"
        ;
    }

    struct Parameterization
        : public ::testing::Test, testing::WithParamInterface<TestParameter>
     // : public ::testing::TestWithParam<TestParameter> // <- can be used instead
    {
    };

    constexpr int INPUT_FOR_CASE_1 = 37456894;
    constexpr int INPUT_FOR_CASE_2 = 0;

    constexpr float EXPECTED_RESULT_FOR_CASE_1 = -0.34257f;
    constexpr float EXPECTED_RESULT_FOR_CASE_2 = 345.5f;
}

INSTANTIATE_TEST_SUITE_P(Numbers, Parameterization, testing::Values(
    TestParameter { INPUT_FOR_CASE_1, EXPECTED_RESULT_FOR_CASE_1, },
    TestParameter { INPUT_FOR_CASE_2, EXPECTED_RESULT_FOR_CASE_2, }
));

TEST_P( Parameterization, Fails_With_A_Nicely_Formatted_Error_Printed_To_Console )
{
    // Arrange
    auto const input = GetParam().INPUT;
    auto const expected_result = GetParam().EXPECTED_RESULT;

    Dummy o { };

    // Act
    auto const result = o.convert( input );

    // Assert
    GTEST_ASSERT_EQ(expected_result, result);
    // GTEST_SKIP();
}

*/
