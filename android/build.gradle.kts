allprojects {
    repositories {
        google()
        mavenCentral()
    }
    // Provide flutter extension to subprojects that reference flutter.compileSdkVersion.
    // Flutter Gradle Plugin only registers this on :app.
    if (project.name != "app") {
        project.extensions.extraProperties.set("flutter", groovy.util.Expando().also { e ->
            e.setProperty("compileSdkVersion", 36)
            e.setProperty("targetSdkVersion", 36)
            e.setProperty("minSdkVersion", 21)
            e.setProperty("ndkVersion", "27.0.12077973")
        })
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
