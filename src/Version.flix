namespace Flixball/Version {

    use SemanticVersion.SemanticVersion

    /// A semantic version number.
    pub enum SemanticVersion(Int32, Int32, Int32)

    /// Returns the current version of Flixball
    pub def version(): SemanticVersion = SemanticVersion(0, 0, 0)

    instance ToString[SemanticVersion] {
    
        pub def toString(x: SemanticVersion): String = {
            let SemanticVersion(major, minor, patch) = x;
            "v${major}.${minor}.${patch}"
        }
    
    }
    
    
}