module fortran2024
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, fortran2024!"
  end subroutine say_hello
end module fortran2024
