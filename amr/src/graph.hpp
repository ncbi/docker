// graph.hpp

#ifndef GRAPH_HPP_73854  // random number
#define GRAPH_HPP_73854


#include "common.hpp"
using namespace Common_sp;



namespace Common_sp
{
using namespace std;



struct DiGraph : Root
// Directed graph
// Bi-directional access
// n = number of nodes
// m = number of arcs
{
  struct Arc; 
  

  struct Node : Root, protected DisjointCluster
  {
    friend struct DiGraph;
    
    const DiGraph* graph {nullptr};
      // nullptr <=> *this is detach()'ed
  private:
    List<Node*>::iterator graphIt;
      // In graph->nodes
  public:
    List<Arc*> arcs [2 /*bool: out*/];

    Node* scc {nullptr};  
      // Strongly-connected component
      // = root of SCC-subtree of DFS tree
      // scc->orderDfs <= orderDfs 
    size_t orderDfs {0};
      // Order by depth-first search
      // 0 <=> not visited by DFS

  private:
    // Auxiliary      
    bool inStack {false};  
      // => orderDfs
  public:

    explicit Node (DiGraph &graph_arg)
			{ attach (graph_arg); }
    Node (const Node &other)
      : Root (other)
      , DisjointCluster (other)
      , scc      (other. scc)
      , orderDfs (other. orderDfs)
      , inStack  (other. inStack)
      {}
      // To be followed by: attach()
    Node* copy () const override
      { return new Node (*this); }
   ~Node ();
      // Remove this from graph 
      // Time: O(m) for all nodes
    void qc () const override;
    void saveText (ostream& os) const override;
      // Invokes: getName(), saveContent()
  protected:
    virtual void saveContent (ostream &/*os*/) const 
      {}
  public:

  	void attach (DiGraph &graph_arg);
      // Requires: !graph; no Arc's
      // Invokes: graph_arg.nodes.push_back(this)
      // Time: O(1)
    virtual string getName () const
      // Return: !empty()
	    { ostringstream oss;
		  	oss << this;
			  return oss. str ();
		  }
    bool isIncident (const Node* n,
                     bool out) const;
      // Return: n is among arcs[out]->node[out]
    VectorPtr<Node> getNeighborhood (bool out) const;
    VectorPtr<Node> getNeighborhood () const
      { return getNeighborhood (false) << getNeighborhood (true); }
      // Return: !contains(this)
    VectorPtr<DiGraph::Node> getChildren () const
      { return getNeighborhood (false); }
    void deleteNeighborhood (bool out);
  private:
    Node* setScc (size_t &visitedNum,
                  stack<Node*, vector<Node*> > &sccStack);
      // If node n is reachable from this then
      //   the SCC of n is reachable from this and the SCC is a subtree of DFS tree
      // Output: scc, orderDfs in nodes reachable from this
      // Tarjan's alogorithm
      // Return: n s.t. n->inStack and there is a path from this to n
      // Requires: n->inStack <=> there is a path from n to this
      // Time: O(n + m) for all nodes

    virtual void contractContent (const Node* /*from*/) {}
      // Required time: O(1)
  public:      
  	Node* getConnectedComponent ()
  	  { return static_cast <Node*> (getDisjointCluster ()); }
    void contract (Node* from);
      // Update: this: No parallel arcs
      // Invokes: contractContent(from), Arc::contractContent(), delete from
      // Requires: from != this
      //           No parallel arcs
      // Time: O(n + m log n) for all nodes
    void isolate ();
      // Make degree = 0
    void detach ();
      // Output: graph = nullptr
      // Requires: No Arc's
      // Invokes: list::erase()
  };


  struct Arc : Root
  {
    friend struct DiGraph;
    friend struct Node;
   
    array <Node*, 2 /*bool: out*/> node;
      // !nullptr
  private:
    array <List<Arc*>::iterator, 2 /*bool: out*/> arcsIt;
      // in node [b] -> arcs [! b]
  public:

    Arc (Node* start,
         Node* end)
      { node [false] = nullptr;
      	node [true]  = nullptr;
      	attach (start, end);
      }
  private:
  	void attach (Node* start,
                 Node* end);
      // Adds *this to the graph
      //   node[i]->arcs[!i].push_back(this)
      // Requires: !node[i]
      // Time: O(1)
  public:
  	Arc (const Arc& other)
  	  : Root (other)
  	  { node [false] = nullptr;
      	node [true]  = nullptr;
      }
      // To be followed by: attach()
    Arc* copy () const override
      { return new Arc (*this); }
   ~Arc ();
      // Remove this from node->graph
      // Time: O(1)

    virtual void saveContent (ostream &/*os*/) const 
      {}
  private:
    virtual void contractContent (const Arc* /*from*/) 
      {}
      // Required time: O(1)
  };


  List<Node*> nodes;
    // size() == n


  DiGraph ()
    {}
  typedef  map <const Node* /*old*/, Node* /*new*/>  Old2new;
  DiGraph (const DiGraph &other)
    { Old2new old2new;
    	init (other, old2new);
    }
  DiGraph (const DiGraph &other,
           Old2new &old2new)
    { init (other, old2new); }
private:
  void init (const DiGraph &other,
             Old2new &old2new);
    // Output: old2new
public:
  DiGraph* copy () const override
    { return new DiGraph (*this); }
 ~DiGraph ();
    // Invokes: Node::delete
    // Time: O(n + m)
  void qc () const override;
  void saveText (ostream &os) const override;


  void connectedComponents ();
    // Output: Node::getConnectedComponent()  
    // Invokes: DisjointCluster::init()
  void scc (); 
    // Output: Node::{scc,orderDfs}
    // Invokes: Node::setScc()
    // Time: O(n + m)
  void contractScc ();
    // Output: DAG
    // Requires: After scc()
    // Invokes: Node::contract()
    // Time: O(n + m log n)
  VectorPtr<Node> getEnds (bool out) const;
    // Return: distinct, !nullptr
    // Input: out: false - roots
    //             true  - leaves
  const Node* getRoot (bool out) const
		{ const VectorPtr<DiGraph::Node> ends (getEnds (out));
			if (ends. size () == 1)
			  return * ends. begin ();
			return nullptr;
		}
  typedef  map <const Node*, const Node*>  Node2Node;  
    // !nullptr
  static Node2Node reverse (const Node2Node& old2new);
  void borrowArcs (const Node2Node &other2this,
                   bool parallelAllowed);
    // Input: other2this: other node to *this node
    // Time: O(|other2this| log|other2this| outdegree_max (parallelAllowed ? 1 : outdegree'_max)),
    //          where outdegree_max  = max(outdegree(other2this.keys()),
    //                outdegree'_max = max(outdegree(other2this.values())
};



struct Tree : DiGraph
// Parent <=> out = true
{
	struct TreeNode : DiGraph::Node
	{
	  friend struct Tree;
	  bool frequentChild {false};
	    // For a directed tree
	  size_t frequentDegree {0};
	    // For an undirected tree
	    // If isLeafType(): 0 or 1; 0 <=> unstable given rareProb
	  size_t leaves {0};

		TreeNode (Tree &tree,
		          TreeNode* parent_arg)
			: DiGraph::Node (tree)
			{ setParent (parent_arg); }
		  // Input: parent_arg: may be nullptr
		void qc () const override;
   	void saveText (ostream &os) const override;
   	  // Invokes: getName(), saveContent(), getSaveSubtreeP()

    virtual bool getSaveSubtreeP () const 
      { return true; }
	  virtual double getParentDistance () const
	    { return -1; }
	    // Return: -1 || >= 0
	  virtual string getNewickName (bool /*minimal*/) const
	    { return getName (); }
		static string name2newick (const string &s);
	private:
	  void printNewick_ (ostream &os,
	                     bool internalNames,
	                     bool minimalLeafName) const;
	    // Input: os.setprecision
	    // Invokes: getParentDistance(), getNewickName(), name2newick()
  public:
	  const Tree& getTree () const
  	  { return * static_cast <const Tree*> (graph); }
		bool isLeaf () const
		  { return arcs [false]. empty (); }
		virtual bool isLeafType () const
		  { return false; }
		virtual bool isInteriorType () const
		  { return false; }
		const TreeNode* getParent () const
			{ return arcs [true]. empty () ? nullptr : static_cast <TreeNode*> (arcs [true]. front () -> node [true]); }
		  // Return: nullptr <=> root
		const TreeNode* getAncestor (size_t height) const;
		  // Return: !nullptr
		  // getAncestor(0) = this
		void setParent (TreeNode* newParent);
		  // Update: *newParent; makes *this the last child of *newParent
		  //         getTree()->root if !newParent
    void printAncestors (const TreeNode* end) const;
    struct TipName : Root
    { string name; 
      size_t depth {0}; 
      TipName ()
        {}
      TipName (const string &name_arg,
               size_t depth_arg)
        : name (name_arg)
        , depth (depth_arg)
        {}
      void saveText (ostream &os) const override
        { os << name << '\t' << depth; }
    };
    TipName getTipName () const;
      // Return: identification of *this by a tip
		size_t getTopologicalDepth () const
		  { if (const TreeNode* parent_ = getParent ())
		  		return parent_->getTopologicalDepth () + 1;
		  	return 0;
		  }
		struct NodeDist
		{ const TreeNode* node;
		  double dist;
		  static bool distLess (const NodeDist &x,
		                        const NodeDist &y) 
		    { return x. dist < y. dist; }
		  bool operator< (const NodeDist &other) const
		    { return node < other. node; }
		  bool operator== (const NodeDist &other) const
		    { return node == other. node; }
		};
		void getSubtreeHeights (Vector<NodeDist> &nodeHeights) const;
		  // Append: nodeHeights: interior nodes
		  // Invokes: getParentDistance()
    void getLeafDepths (Vector<NodeDist> &leafDepths,
                        bool first = true) const;
		  // Append: leafDepths: leaves
		  // Invokes: getParentDistance()
		size_t getHeight () const;
		  // Return: 0 <=> isLeaf()
		size_t getInteriorHeight () const;
    void getBifurcatingInteriorBranching (size_t &bifurcatingInteriorNodes,
                                          size_t &branches) const;
      // Update: bifurcatingInteriorNodes, branches
      //         branches >= bifurcatingInteriorNodes
      //         branches <= 2 bifurcatingInteriorNodes
	  double getRootDistance () const
		  { if (const TreeNode* parent_ = getParent ())
		  		return parent_->getRootDistance () + getParentDistance ();
		  	return 0;
		  }
		bool descendantOf (const TreeNode* ancestor) const
		  { if (! ancestor)
		  	  return true;
		  	if (this == ancestor)
		  		return true;
		  	if (const TreeNode* parent_ = getParent ())
		  		return parent_->descendantOf (ancestor);
		  	return false;
		  }
		const TreeNode* getPrevAncestor (const TreeNode* ancestor) const
		  { if (! ancestor)
		      return nullptr;
		    const TreeNode* parent_ = getParent ();
		    if (parent_ == ancestor)
		      return this;
		    if (! parent_)
		      return nullptr;
		    return parent_->getPrevAncestor (ancestor);
		  }
		size_t getSubtreeSize (bool countLeaves) const;
		  // Return: # Arc's in the subtree
		  //         0 <= isLeaf()
		  // Input: !countLeaves => leaf arcs are ignored
    double getSubtreeLength () const;
		  // Return: 0 <= isLeaf()
		void setLeaves ();
		  // Output: leaves
		size_t getLeavesSize () const;
		void children2frequentChild (double rareProb);
		  // Input: leaves
		  // Output: TreeNode::frequentChild
		  // Invokes: isInteriorType()
    void getLeaves (VectorPtr<TreeNode> &leafVec) const;
      // Update: leafVec
		const TreeNode* getClosestLeaf (size_t &leafDepth) const;
		  // Return: !nullptr
		  // Output: leafDepth; nullptr <=> Return = this
    const TreeNode* getOtherChild (const TreeNode* child) const;
      // Return: May be nullptr; != child
      // Requires: getChildren().size() <= 2
    const TreeNode* getDifferentChild (const TreeNode* child) const;
      // Return: !nullptr; != child
    const TreeNode* getLeftmostDescendant () const;
    const TreeNode* getRightmostDescendant () const;
    string getLcaName () const
      { return getLeftmostDescendant () -> getName () + objNameSeparator + getRightmostDescendant () -> getName (); }
	  void childrenUp ();
	    // Children->setParent(getParent())
	    // Post-condition: arcs[false].empty()
	  TreeNode* isTransient () const
	    { return arcs [false]. size () == 1 
	    	        ? static_cast <TreeNode*> (arcs [false]. front () -> node [false]) 
	    	        : nullptr; 
	    }
	    // Return: Single child of *this
	  void detachChildrenUp ();
	    // Invokes: childrenUp(), detach()
	  TreeNode* isolateTransient ()
			{ TreeNode* transient = isTransient ();
				if (transient)
					detachChildrenUp ();
			  return transient;
			}
	  bool deleteTransient ()
	    { if (! isolateTransient ())
		 			return false;
		    delete this;
        return true;
	    }
	  void deleteSubtree ();
	    // Postcondition: isLeaf()
	  const TreeNode* makeRoot ();
	    // Redirect TreeArc's so that this = getTree()->root
	    // Return: old getTree()->root, !nullptr
    void getArea (uint radius,
                  VectorPtr<TreeNode> &area,
                  VectorPtr<TreeNode> &boundary) const
      { getArea_ (radius, nullptr, area, boundary); }
      // Output: area: connected TreeNode's with one root, distinct
      //         boundary: distinct; degree = 1 in the subgraph
      //         area.contains(boundary)
  private:
    void getArea_ (uint radius,
                   const TreeNode* prev,
                   VectorPtr<TreeNode> &area,
                   VectorPtr<TreeNode> &boundary) const;
      // Update: area, boundary
      //         area.contains(boundary)
  public:
    template <typename StrictlyLess>
    	void sort (const StrictlyLess &strictlyLess)
  			{ VectorPtr<DiGraph::Node> children (getChildren ());
  				Common_sp::sort (children, strictlyLess);
  				for (const DiGraph::Node* child : children)
  				{	TreeNode* s = const_static_cast <TreeNode*> (child);
  					s->setParent (const_cast <TreeNode*> (s->getParent ()));  // To reorder arcs[false]
  				  s->sort (strictlyLess);
  				}
  			}
	};
	const TreeNode* root {nullptr};
	  // nullptr <=> nodes.empty()
  static const char objNameSeparator {':'};


  Tree ()
    {}
  void qc () const override;
	void saveText (ostream &os) const override
	  { if (root)
	  	  root->saveText (os);
      os << endl;
    }


  void printNewick (ostream &os,
                    bool internalNames,
                    bool minimalLeafName) const
    { root->printNewick_ (os, internalNames, minimalLeafName);
    	os << ';' << endl;
    }
    // Input: internalNames <=> print name at each internal node
  void printAsn (ostream &os) const;	
    // http://www.ncbi.nlm.nih.gov/tools/treeviewer/biotreecontainer/
  void printArcLengths (ostream &os) const;
    // Output: os: <printArcLengthsColumns()>
    // Requires: getParentDistance() > 0 for all nodes except root
  static string printArcLengthsColumns ()
    { return "<node name> <arc length> <depth length> <log(<parent arc length>/<arc length>)"; }
  double getLength () const
    { return root->getSubtreeLength (); }
  double getAveArcLength () const;
  struct Patristic
  {
    const TreeNode* leaf1 {nullptr};
    const TreeNode* leaf2 {nullptr};  
      // != nullptr
      // leaf1->getName() < leaf2->getName()
    double distance {0};
    Patristic (const TreeNode* leaf1_arg, 
               const TreeNode* leaf2_arg,
               double distance_arg);        
    Patristic ()
      {}
  };
  Vector<Patristic> getLeafDistances () const;
  void setLeaves ()
    { if (root)
        const_cast <TreeNode*> (root) -> setLeaves (); 
    }
  size_t size (bool countLeaves) const
    { return nodes. size () <= 1
               ? countLeaves
               : 1 + root->getSubtreeSize (countLeaves); 
    }
  size_t countInteriorNodes () const;
    // Input: TreeNode::isInteriorType()
  bool isStar () const
    { return countInteriorNodes () == 1; }
  size_t getInteriorHeight () const
    { if (root && root->isInteriorType ())
        return root->getInteriorHeight ();
      return 0;
    }
  double getBifurcatingInteriorBranching () const;
    // For unrooted tree
    // Return: if !root->isInteriotType() then -1 else between 1 and 2
    // # Bifurcating interior nodes = [1 1]' [[branching 0]' [1 1]']^depth [1 0] = \sum_{i=0}^depth branching^i = branching^{depth+1} - 1
    //   Vector meaning: [open_nodes closed_nodes]
    // # Leaves = # Bifurcating interior nodes + 1 = branching^{depth+1}
  size_t countInteriorUndirectedArcs () const;
    // Arc is interior <=> arc's nodes are interior
    // Return: <= countInteriorNodes()
    // Invokes: countInteriorNodes()
  static const TreeNode* getLca (const TreeNode* n1,
                                 const TreeNode* n2);
    // Return: nullptr <=> !n1 || !n2
  static const TreeNode* getLca (const VectorPtr<TreeNode> &nodeVec);
    // Return: nullptr <= nodeVec.empty()
    // Input: nodeVec: may be nullptr
  static Set<const TreeNode*> getParents (const VectorPtr<TreeNode> &nodeVec);
    // Return: !nullptr, !contains(getLca(nodeVec)), contains(nodeVec)
    // Invokes: getLca(nodeVec)
  static VectorPtr<TreeNode> getPath (const TreeNode* n1,
                                      const TreeNode* n2,
                                      const TreeNode* ca,
                                      const TreeNode* &lca);
    // Return: sequential arcs on the path from n1 to n2, distinct, !nullptr
    // Input: ca: may be nullptr
    // Output: lca: !nullptr
    // Requires: ca is the common ancestor of n1 and n2
  void setFrequentChild (double rareProb);
    // Input: 0 <= rareProb < 0.5
    // Output: TreeNode::frequentChild: statistically consistent estimate
    // Invokes: setLeaves(), children2frequentChild()
  void setFrequentDegree (double rareProb);
    // Input: 0 <= rareProb < 0.3
    // Output: TreeNode::frequentDegree: statistically consistent estimate
    // Invokes: setLeaves(), TreeNode::isLeafType()
  void setRoot ();
    // Output: root
  size_t deleteTransients ();
    // Return: # TreeNode's delete'd
  virtual void deleteLeaf (TreeNode* leaf,
                           bool /*deleteTransientAncestor*/) 
    { delete leaf; }
  size_t restrictLeaves (const StringVector &leafNames,
                         bool deleteTransientAncestor);
    // Return: # leaves delete'd
    // Input: leafNames: sort()'ed
    // Invokes: isLeafType(), deleteLeaf()

  template <typename StrictlyLess>
    void sort (const StrictlyLess &strictlyLess)
      { if (root)
      	  const_cast <TreeNode*> (root) -> sort (strictlyLess); 
      }
private:
	static bool strictlyLess_std (const DiGraph::Node* a,
	                              const DiGraph::Node* b);

public:
  void sort ()
    { setLeaves ();
      sort (strictlyLess_std); 
    }
};



}



#endif

