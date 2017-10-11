//
//  Quickly
//

extension QApiProvider {

    internal func set(query: IQApiQuery) {
        self.queue.sync {
            self.queries[query.task!.taskIdentifier] = query
        }
    }

    internal func getQuery(task: URLSessionTask) -> IQApiQuery? {
        var query: IQApiQuery? = nil
        self.queue.sync {
            query = self.queries[task.taskIdentifier]
        }
        return query
    }

    internal func removeQuery(task: URLSessionTask) -> IQApiQuery? {
        var query: IQApiQuery? = nil
        self.queue.sync {
            let key: Int = task.taskIdentifier
            query = self.queries[key]
            self.queries.removeValue(forKey: key)
        }
        return query
    }

    internal func moveQuery(fromTask: URLSessionTask, toTask: URLSessionTask) -> IQApiQuery? {
        var query: IQApiQuery? = nil
        self.queue.sync {
            query = self.queries[fromTask.taskIdentifier]
            self.queries.removeValue(forKey: fromTask.taskIdentifier)
            if let query: IQApiQuery = query {
                self.queries[toTask.taskIdentifier] = query
            }
        }
        return query
    }

}
