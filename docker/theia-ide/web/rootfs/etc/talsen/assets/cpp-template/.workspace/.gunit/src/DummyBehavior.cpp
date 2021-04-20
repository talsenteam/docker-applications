
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
