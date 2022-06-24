//
//  GitBranchesInteractorTests.swift
//  
//
//  Created by Kryštof Matěj on 23.06.2022.
//

@testable import SwiftTools
import XCTest

final class GitBranchesInteractorTests: XCTestCase {
    private var gitServiceSpy: GitServiceSpy!
    private var sut: GitBranchesInteractorImpl!

    override func setUp() {
        super.setUp()
        gitServiceSpy = GitServiceSpy(
            getRemoteBranchesReturn: [
                "2022.4/release",
                "2022.4/develop",
                "2022.3.1/develop",
                "2022.3/develop",
                "2022.3/feature/1",
                "2022.3/bugfix/2",
            ],
            getStatusReturn: "",
            getCurrentHashReturn: "",
            getCurrentMessageReturn: "",
            getLatestHashReturn: ""
        )
        sut = GitBranchesInteractorImpl(gitService: gitServiceSpy)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_whenGetReleaseBranches_thenReturnSortedBranches() throws {
        let branches = try sut.getReleaseBranches()

        XCTAssertEqual(branches.count, 4)
        XCTAssertEqual(branches[safe: 0]?.name, "2022.3/develop")
        XCTAssertEqual(branches[safe: 1]?.name, "2022.3.1/develop")
        XCTAssertEqual(branches[safe: 2]?.name, "2022.4/develop")
        XCTAssertEqual(branches[safe: 3]?.name, "2022.4/release")
    }
}

final class GitServiceSpy: GitService {
    enum SpyError: Error {
        case spyError
    }
    typealias ThrowBlock = () throws -> Void

    struct Push {
        let branchName: String
    }

    struct ForcePush {
        let branchName: String
    }

    struct ForcePushWithLease {
        let branchName: String
    }

    struct Checkout {
        let identifier: String
    }

    struct Merge {
        let sourceHash: String
    }

    struct Commit {
        let message: String
    }

    struct GetStatus {
        let arguments: [String]
    }

    struct Rebase {
        let branchName: String
    }

    struct GetLatestHash {
        let branchName: String
    }

    struct PushTag {
        let tag: String
    }

    var resetRepositoryCount = 0
    var resetRepositoryThrowBlock: ThrowBlock?
    var getRemoteBranchesCount = 0
    var getRemoteBranchesThrowBlock: ThrowBlock?
    var getRemoteBranchesReturn: Set<String>
    var pullCount = 0
    var pullThrowBlock: ThrowBlock?
    var push = [Push]()
    var pushThrowBlock: ThrowBlock?
    var forcePush = [ForcePush]()
    var forcePushThrowBlock: ThrowBlock?
    var forcePushWithLease = [ForcePushWithLease]()
    var forcePushWithLeaseThrowBlock: ThrowBlock?
    var checkout = [Checkout]()
    var checkoutThrowBlock: ThrowBlock?
    var updateSubmoduleCount = 0
    var updateSubmoduleThrowBlock: ThrowBlock?
    var merge = [Merge]()
    var mergeThrowBlock: ThrowBlock?
    var commit = [Commit]()
    var commitThrowBlock: ThrowBlock?
    var getStatus = [GetStatus]()
    var getStatusThrowBlock: ThrowBlock?
    var getStatusReturn: String
    var rebase = [Rebase]()
    var rebaseThrowBlock: ThrowBlock?
    var amendCount = 0
    var amendThrowBlock: ThrowBlock?
    var addAllCount = 0
    var addAllThrowBlock: ThrowBlock?
    var fetchOriginCount = 0
    var fetchOriginThrowBlock: ThrowBlock?
    var getCurrentHashCount = 0
    var getCurrentHashThrowBlock: ThrowBlock?
    var getCurrentHashReturn: String
    var getCurrentMessageCount = 0
    var getCurrentMessageThrowBlock: ThrowBlock?
    var getCurrentMessageReturn: String
    var getLatestHash = [GetLatestHash]()
    var getLatestHashThrowBlock: ThrowBlock?
    var getLatestHashReturn: String
    var resetHardCount = 0
    var resetHardThrowBlock: ThrowBlock?
    var pushTag = [PushTag]()
    var pushTagThrowBlock: ThrowBlock?

    init(getRemoteBranchesReturn: Set<String>, getStatusReturn: String, getCurrentHashReturn: String, getCurrentMessageReturn: String, getLatestHashReturn: String) {
        self.getRemoteBranchesReturn = getRemoteBranchesReturn
        self.getStatusReturn = getStatusReturn
        self.getCurrentHashReturn = getCurrentHashReturn
        self.getCurrentMessageReturn = getCurrentMessageReturn
        self.getLatestHashReturn = getLatestHashReturn
    }

    func resetRepository() throws {
        resetRepositoryCount += 1
        try resetRepositoryThrowBlock?()
    }

    func getRemoteBranches() throws -> Set<String> {
        getRemoteBranchesCount += 1
        try getRemoteBranchesThrowBlock?()
        return getRemoteBranchesReturn
    }

    func pull() throws {
        pullCount += 1
        try pullThrowBlock?()
    }

    func push(to branchName: String) throws {
        let item = Push(branchName: branchName)
        push.append(item)
        try pushThrowBlock?()
    }

    func forcePush(to branchName: String) throws {
        let item = ForcePush(branchName: branchName)
        forcePush.append(item)
        try forcePushThrowBlock?()
    }

    func forcePushWithLease(to branchName: String) throws {
        let item = ForcePushWithLease(branchName: branchName)
        forcePushWithLease.append(item)
        try forcePushWithLeaseThrowBlock?()
    }

    func checkout(_ identifier: String) throws {
        let item = Checkout(identifier: identifier)
        checkout.append(item)
        try checkoutThrowBlock?()
    }

    func updateSubmodule() throws {
        updateSubmoduleCount += 1
        try updateSubmoduleThrowBlock?()
    }

    func merge(from sourceHash: String) throws {
        let item = Merge(sourceHash: sourceHash)
        merge.append(item)
        try mergeThrowBlock?()
    }

    func commit(with message: String) throws {
        let item = Commit(message: message)
        commit.append(item)
        try commitThrowBlock?()
    }

    func getStatus(with arguments: [String]) throws -> String {
        let item = GetStatus(arguments: arguments)
        getStatus.append(item)
        try getStatusThrowBlock?()
        return getStatusReturn
    }

    func rebase(onto branchName: String) throws {
        let item = Rebase(branchName: branchName)
        rebase.append(item)
        try rebaseThrowBlock?()
    }

    func amend() throws {
        amendCount += 1
        try amendThrowBlock?()
    }

    func addAll() throws {
        addAllCount += 1
        try addAllThrowBlock?()
    }

    func fetchOrigin() throws {
        fetchOriginCount += 1
        try fetchOriginThrowBlock?()
    }

    func getCurrentHash() throws -> String {
        getCurrentHashCount += 1
        try getCurrentHashThrowBlock?()
        return getCurrentHashReturn
    }

    func getCurrentMessage() throws -> String {
        getCurrentMessageCount += 1
        try getCurrentMessageThrowBlock?()
        return getCurrentMessageReturn
    }

    func getLatestHash(of branchName: String) throws -> String {
        let item = GetLatestHash(branchName: branchName)
        getLatestHash.append(item)
        try getLatestHashThrowBlock?()
        return getLatestHashReturn
    }

    func resetHard() throws {
        resetHardCount += 1
        try resetHardThrowBlock?()
    }

    func pushTag(_ tag: String) throws {
        let item = PushTag(tag: tag)
        pushTag.append(item)
        try pushTagThrowBlock?()
    }
}
