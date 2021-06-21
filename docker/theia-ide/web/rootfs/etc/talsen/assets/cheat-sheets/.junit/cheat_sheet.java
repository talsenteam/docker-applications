package team.talsen.kata.cheats;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.util.Arrays;
import java.util.Collection;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(Parameterized.class)
public class ParameterizedDummyTest
{
    @Parameters
    public static Collection< Object[ ] > data( ) {
        return Arrays.asList( new Object [ ] [ ] {
            { 0, "0" },
            { 1, "1" },
            { 2, "2" },
            { 4, "4" },
        });
    }

    private final int INPUT;
    private final String EXPECTED_RESULT;

    public ParameterizedDummyTest( int input, String expectedResult )
    {
        this.INPUT = input;
        this.EXPECTED_RESULT = expectedResult;
    }

    @Test
    public void testThatNumberIsConvertedToExpectedString( )
    {
        // Arrange

        // Act
        final String result = Dummy.numberToString( this.INPUT );

        // Assert
        assertThat( this.EXPECTED_RESULT ).isEqualTo( result );
    }
}
