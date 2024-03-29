//
//  File.swift
//  
//
//  Created by Jan Halousek on 29.03.2022.
//

import Swinject

public enum SwiftToolsAssemblies {
    public static func getAllAssemblies() -> [Assembly] {
        return [
            CleanupAssembly(),
            FastlaneServiceAssembly(),
            FullVersionAssembly(),
            GitAssembly(),
            HashServiceAssembly(),
            LocalFileAssembly(),
            NetworkAssembly(),
            PrintAssembly(),
            ShellAssembly(),
            MergeAssembly(),
            SynchronizeLatestReleaseAssembly(),
            UpdateAssembly(),
            JsonSerializerAssembly(),
            BuildAssembly(),
        ]
    }
}
