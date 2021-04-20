
import {sum} from "./sum";

describe('sum', () => {
    it('should add 1 + 2 correctly', () =>  {
        expect(sum(1, 2)).toBe(3);
    });
});
