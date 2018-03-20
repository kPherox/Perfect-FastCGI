/**
 *  HTTPResponse++.swift
 *  Osmanthus
 *
 *  © 2018 kPherox.
**/

import PerfectLib

#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif

extension PerfectServer {

    public static func switchTo(groupName gnam: String) throws {
        guard let gr = getgrnam(gnam) else {
            try ThrowSystemError()
        }

        let gid = gr.pointee.gr_gid

        if setgid(gid) != 0 {
            try ThrowSystemError()
        }
    }

    public static func switchTo(userName unam: String, groupName gnam: String) throws {
        guard let pw = getpwnam(unam) else {
            try ThrowSystemError()
        }

        guard let gr = getgrnam(gnam) else {
            try ThrowSystemError()
        }

        let gid = gr.pointee.gr_gid
        let uid = pw.pointee.pw_uid

        if setgid(gid) != 0 {
            try ThrowSystemError()
        }

        if setgid(uid) != 0 {
            try ThrowSystemError()
        }
    }

}

private var errno: Int32 {
    return __errno_location().pointee
}

private func ThrowSystemError(file: String = #file, function: String = #function, line: Int = #line) throws -> Never  {
    let err = errno
    let msg = String(validatingUTF8: strerror(err))!

    throw PerfectError.systemError(err, msg + " \(file) \(function) \(line)")
}


