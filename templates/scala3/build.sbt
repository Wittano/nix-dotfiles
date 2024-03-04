ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.4.0"

lazy val root = (project in file("."))
  .settings(
    name := "scala",
    idePackagePrefix := Some("com.wittano")
  )

libraryDependencies += "org.scalatest" %% "scalatest-funsuite" % "3.2.17" % "test"
