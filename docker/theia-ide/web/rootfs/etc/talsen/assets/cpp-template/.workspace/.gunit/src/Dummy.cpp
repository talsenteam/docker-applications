
#include "Dummy.hpp"

int Dummy::get_value() const
{
  return 8;
}

float Dummy::convert(int input) const
{
  return static_cast<float>(input);
}
