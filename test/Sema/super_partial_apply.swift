// RUN: %target-swift-frontend -parse -verify %s

func doFoo(f: () -> ()) {
  f()
}

class Base {
  // expected-error@+1 {{curried function declaration syntax has been removed; use a single parameter list}}
  func foo()() {}
  func bar() {}
}

class Derived : Base {
  // expected-error@+1 {{curried function declaration syntax has been removed; use a single parameter list}}
  override func foo()() {
    doFoo(super.foo()) // expected-error {{partial application of 'super' method is not allowed}}
  }
  override func bar() {
    doFoo(super.bar) // OK - only captures implicit self
  }
}

class BaseWithFinal {
  // expected-error@+1 {{curried function declaration syntax has been removed; use a single parameter list}}
  final func foo()() {}
}

class DerivedWithFinal : BaseWithFinal {
  func bar() {
    doFoo(super.foo()) // expected-error {{partial application of 'super' method is not allowed}}
  }
}
