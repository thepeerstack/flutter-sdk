enum ThePeerEnv { test, live }

extension ThePeerEnvironment on ThePeerEnv {
  bool get isLive => this == ThePeerEnv.live;
  bool get isTest => this == ThePeerEnv.test;
}
