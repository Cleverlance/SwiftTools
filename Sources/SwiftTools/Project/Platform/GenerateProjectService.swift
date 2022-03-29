//
//  File.swift
//
//
//  Created by Kryštof Matěj on 06.01.2021.
//

import Foundation
import PathKit
import ProjectSpec
import SwiftCLI
import Version
import XcodeGenKit
import XcodeProj

public protocol GenerateProjectService {
    func generateProject(path: String) throws
}

final class GenerateProjectServiceImpl: GenerateProjectService {
    // Contents of GenerateCommand.swift + ProjectCommand.swift from XcodeGen
    func generateProject(path: String) throws {
        let projectSpecPath = Path(path)
        let projectRoot = Path.current
        let projectDirectory = projectSpecPath.parent()

        if !projectSpecPath.exists {
            throw ToolsError(description: "Project generating missing `project.yml` at path: \(projectSpecPath)")
        }

        let specLoader = SpecLoader(version: "1.0.0")
        let project: ProjectSpec.Project

        do {
            project = try specLoader.loadProject(path: projectSpecPath, projectRoot: projectRoot, variables: [:])
        } catch {
            throw ToolsError(description: "project generating failed to load `project.yml`")
        }

        // validate project dictionary
        do {
            try specLoader.validateProjectDictionaryWarnings()
        } catch {
            throw ToolsError(description: "")
        }

        let projectPath = projectDirectory + "\(project.name).xcodeproj"

        // validate project
        do {
            try project.validateMinimumXcodeGenVersion("12.3")
            try project.validate()
        } catch {
            throw ToolsError(description: "Project generation invalid project with error: \(error)")
        }

        // run pre gen command
        if let command = project.options.preGenCommand {
            try Task.run(bash: command, directory: projectDirectory.absolute().string)
        }

        // generate plists
//        info("⚙️  Generating plists...")
        let fileWriter = FileWriter(project: project)
        do {
            try fileWriter.writePlists()
        } catch {
            throw ToolsError(description: "Project generation cound not generate plist with error \(error)")
        }

        // generate project
//        info("⚙️  Generating project...")
        let xcodeProject: XcodeProj
        do {
            let projectGenerator = ProjectGenerator(project: project)
            xcodeProject = try projectGenerator.generateXcodeProject(in: projectDirectory)
        } catch {
            throw ToolsError(description: "Project generation cound not generate project with error: \(error)")
        }

        // write project
//        info("⚙️  Writing project...")
        do {
            try fileWriter.writeXcodeProject(xcodeProject, to: projectPath)
//            success("Created project at \(projectPath)")
        } catch {
            throw ToolsError(description: "Project generation cound not save project to disk with error: \(error)")
        }

        // run post gen command
        if let command = project.options.postGenCommand {
            try Task.run(bash: command, directory: projectDirectory.absolute().string)
        }
    }
}
